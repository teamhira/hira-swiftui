//
//  RecitationManager.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import Foundation
import Combine
import AVFoundation

public enum AudioPlaybackStatus: Equatable {
    case idle
    case loading
    case playing
    case paused
    case error(String)
}

public protocol RecitationManager {
    var status: AudioPlaybackStatus { get }
    var currentTime: Double { get }
    var duration: Double { get }
    var playbackRate: Float { get set }
    var activeVerseKey: String? { get }
    var activeWordIndex: Int? { get }
    var repeatMode: String { get set }
    var onVerseFinished: (() -> Void)? { get set }
    var onVerseKeyChanged: ((String?) -> Void)? { get set }
    var isPlayingChapter: Bool { get }
    
    func playChapter(surahNumber: Int, recitationId: Int, atVerseKey: String?)
    func playVerseSequence(verses: [(key: String, url: String, segments: [[Double]]?)], startIndex: Int)
    func playAyah(_ ayah: Ayah)
    func playVerse(key: String, audio: VerseAudio?, words: [Word]?)
    func playWords(_ words: [Word])
    func togglePlayPause()
    func seek(to seconds: Double)
    func stop()
}

@Observable
public class RecitationManagerImpl: NSObject, RecitationManager {
    public private(set) var status: AudioPlaybackStatus = .idle
    public private(set) var currentTime: Double = 0
    public private(set) var duration: Double = 0
    public var playbackRate: Float = 1.0 {
        didSet { player?.rate = status == .playing ? playbackRate : 0 }
    }
    public private(set) var activeVerseKey: String?
    public private(set) var activeWordIndex: Int?
    public var repeatMode: String = "never"
    public var onVerseFinished: (() -> Void)?
    public var onVerseKeyChanged: ((String?) -> Void)?
    public private(set) var isPlayingChapter: Bool = false
    
    private let repository: AudioRepository
    private var player: AVPlayer?
    private var queuePlayer: AVQueuePlayer? { player as? AVQueuePlayer }
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()
    private var timestamps: [AudioTimestampModel] = []
    
    private var wordMapping: [AVPlayerItem: Int] = [:]
    private var verseKeyMapping: [AVPlayerItem: String] = [:]
    private var segmentsMapping: [AVPlayerItem: [[Double]]] = [:]
    private var isPlayingWordByWord: Bool = false
    
    private var isManualSeeking = false
    
    // Cached chapter data to avoid re-fetching when seeking in same chapter
    private var currentChapterNumber: Int?
    private var currentReciterId: Int?
    
    public init(repository: AudioRepository) {
        self.repository = repository
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch {
            print("❌ RecitationManager: Failed to set up audio session category: \(error)")
        }
    }
    
    public func playChapter(surahNumber: Int, recitationId: Int, atVerseKey: String? = nil) {
        if currentChapterNumber == surahNumber && currentReciterId == recitationId && player != nil {
            // Already loaded, just seek if verseKey provided
            if let key = atVerseKey {
                seekToVerse(key)
            }
            player?.play()
            status = .playing
            return
        }
        
        stopAnyPlayback()
        status = .loading
        currentChapterNumber = surahNumber
        currentReciterId = recitationId
        isPlayingChapter = true
        
        repository.getAudioByChapter(recitationId: recitationId, chapterNumber: surahNumber, segments: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.status = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] audioFile in
                self?.timestamps = audioFile.timestamps ?? []
                self?.preparePlayer(url: audioFile.audioUrl) {
                    if let key = atVerseKey {
                        self?.seekToVerse(key)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func seekToVerse(_ key: String) {
        guard let ts = timestamps.first(where: { $0.verseKey == key }) else { return }
        let time = CMTime(seconds: ts.timestampFrom / 1000.0, preferredTimescale: 600)
        
        // Block auto-highlighting during manual seek to prevent flickering
        isManualSeeking = true
        activeVerseKey = key
        activeWordIndex = nil // Reset word highlight on ayah skip
        onVerseKeyChanged?(key)
        
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isManualSeeking = false
            }
        }
    }
    
    public func playAyah(_ ayah: Ayah) {
        playVerse(key: ayah.verseKey, audio: ayah.audio, words: ayah.words)
    }
    
    public func playVerse(key: String, audio: VerseAudio?, words: [Word]?) {
        stopAnyPlayback()
        status = .loading
        activeVerseKey = key
        
        if let audio = audio, let url = audio.url {
            let segs = audio.segments?.map { $0.map { Double($0) } }
            self.timestamps = [
                AudioTimestampModel(verseKey: key, timestampFrom: 0, timestampTo: 999999, duration: 0, segments: segs)
            ]
            preparePlayer(url: url)
        } else if let words = words {
            playWords(words)
        }
    }
    
    public func playWords(_ words: [Word]) {
        stopAnyPlayback()
        status = .loading
        isPlayingWordByWord = true
        wordMapping = [:]
        
        let baseUrl = "https://audio.qurancdn.com/"
        var items: [AVPlayerItem] = []
        
        for word in words {
            guard let relativeUrl = word.audioUrl else { continue }
            let fullUrl = relativeUrl.hasPrefix("http") || relativeUrl.hasPrefix("//") ? relativeUrl : (baseUrl + relativeUrl)
            var normalizedUrl = fullUrl
            if normalizedUrl.hasPrefix("//") { normalizedUrl = "https:" + normalizedUrl }
            
            if let url = URL(string: normalizedUrl) {
                let item = AVPlayerItem(url: url)
                wordMapping[item] = word.position
                items.append(item)
            }
        }
        
        setupQueuePlayer(items: items)
    }
    
    public func playVerseSequence(verses: [(key: String, url: String, segments: [[Double]]?)], startIndex: Int = 0) {
        stopAnyPlayback()
        status = .loading
        isPlayingChapter = true
        isPlayingWordByWord = false
        wordMapping.removeAll()
        verseKeyMapping.removeAll()
        segmentsMapping.removeAll()
        timestamps.removeAll()
        
        let baseUrl = "https://audio.qurancdn.com/"
        var items: [AVPlayerItem] = []
        
        for (index, verse) in verses.enumerated() {
            let relativeUrl = verse.url
            let fullUrl = relativeUrl.hasPrefix("http") || relativeUrl.hasPrefix("//") ? relativeUrl : (baseUrl + relativeUrl)
            var normalizedUrl = fullUrl
            if normalizedUrl.hasPrefix("//") { normalizedUrl = "https:" + normalizedUrl }
            
            if let url = URL(string: normalizedUrl) {
                let item = AVPlayerItem(url: url)
                verseKeyMapping[item] = verse.key
                if let segs = verse.segments {
                    segmentsMapping[item] = segs
                }
                if index >= startIndex {
                    items.append(item)
                }
            }
        }
        
        setupQueuePlayer(items: items)
    }
    
    private func setupQueuePlayer(items: [AVPlayerItem]) {
        guard !items.isEmpty else {
            status = .idle
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ RecitationManager: Failed to activate audio session for queue: \(error)")
        }
        
        let qPlayer = AVQueuePlayer(items: items)
        self.player = qPlayer
        
        qPlayer.publisher(for: \.currentItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItem in
                guard let self = self, let item = newItem else { 
                    if self?.queuePlayer?.items().isEmpty == true {
                        self?.handleCompletion()
                    }
                    return 
                }
                
                if let position = self.wordMapping[item] {
                    self.activeWordIndex = position
                }
                
                if let vKey = self.verseKeyMapping[item] {
                    self.activeVerseKey = vKey
                    self.onVerseKeyChanged?(vKey)
                    if let segs = self.segmentsMapping[item] {
                        self.timestamps = [
                            AudioTimestampModel(verseKey: vKey, timestampFrom: 0, timestampTo: 999999, duration: 0, segments: segs)
                        ]
                    } else {
                        self.timestamps = []
                    }
                }
                
                item.publisher(for: \.status)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] status in
                        if status == .readyToPlay {
                            self?.duration = item.duration.seconds
                            self?.status = .playing
                        }
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
            
        addTimeObserver()
        qPlayer.play()
        qPlayer.rate = playbackRate
    }
    
    private func preparePlayer(url: String, completion: (() -> Void)? = nil) {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ RecitationManager: Failed to activate audio session: \(error)")
        }
        
        var normalizedUrl = url
        if normalizedUrl.hasPrefix("//") { normalizedUrl = "https:" + normalizedUrl }
        
        guard let audioUrl = URL(string: normalizedUrl) else {
            status = .error("Invalid URL")
            return
        }
        
        let playerItem = AVPlayerItem(url: audioUrl)
        playerItem.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemStatus in
                guard let self = self else { return }
                if itemStatus == .readyToPlay {
                    self.duration = playerItem.duration.seconds
                    self.status = .playing
                    completion?()
                    self.player?.play()
                    self.player?.rate = self.playbackRate
                } else if itemStatus == .failed {
                    self.status = .error("Failed to load")
                }
            }
            .store(in: &cancellables)
        
        self.player = AVPlayer(playerItem: playerItem)
        addTimeObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    private func stopAnyPlayback() {
        player?.pause()
        removeTimeObserver()
        player = nil
        activeWordIndex = nil
        isPlayingWordByWord = false
        isPlayingChapter = false
        cancellables.removeAll()
        currentTime = 0
        duration = 0
        isManualSeeking = false
        // We don't reset currentChapterNumber here to allow seeking if re-playing same chapter
    }
    
    public func stop() {
        stopAnyPlayback()
        currentChapterNumber = nil
        currentReciterId = nil
        activeVerseKey = nil
        status = .idle
    }
    
    public func togglePlayPause() {
        guard let player = player else { return }
        if player.rate == 0 {
            player.play()
            player.rate = playbackRate
            status = .playing
        } else {
            player.pause()
            status = .paused
        }
    }
    
    public func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        isManualSeeking = true
        player?.seek(to: time) { [weak self] _ in
            self?.isManualSeeking = false
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.05, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if !self.isPlayingWordByWord {
                self.updateHighlighting(currentTimeMs: time.seconds * 1000)
            }
        }
    }
    
    private func updateHighlighting(currentTimeMs: Double) {
        guard !isManualSeeking else { return }
        
        if let verse = timestamps.first(where: { currentTimeMs >= $0.timestampFrom && currentTimeMs < $0.timestampTo }) {
            if activeVerseKey != verse.verseKey {
                activeVerseKey = verse.verseKey
                onVerseKeyChanged?(verse.verseKey)
            }
            if let segments = verse.segments {
                // Safely find a segment that has at least [position, start, end] (3 elements)
                // Fix: Include the last word by allowing equality on the end timestamp 
                // and padding slightly for the very last sample of the audio
                let currentSegment = segments.first(where: { segment in
                    segment.count >= 3 && currentTimeMs >= segment[1] && (currentTimeMs <= segment[2] + 10)
                })
                
                if let validSegment = currentSegment, !validSegment.isEmpty {
                    activeWordIndex = Int(validSegment[0])
                } else {
                    activeWordIndex = nil
                }
            } else {
                activeWordIndex = nil
            }
        } else if !isPlayingWordByWord && isPlayingChapter {
            if activeVerseKey != nil {
                activeVerseKey = nil
                onVerseKeyChanged?(nil)
            }
            activeWordIndex = nil
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    @objc private func playerItemDidReachEnd() {
        if !isPlayingWordByWord {
            handleCompletion()
        }
    }
    
    private func handleCompletion() {
        onVerseFinished?()
        
        switch repeatMode {
        case "never":
            status = .idle
        default:
            seek(to: 0)
            player?.play()
            status = .playing
        }
    }
    
    deinit {
        removeTimeObserver()
    }
}
