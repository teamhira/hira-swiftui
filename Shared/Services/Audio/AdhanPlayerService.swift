//
//  AdhanPlayerService.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import AVFoundation
import MediaPlayer

public class AdhanPlayerService: NSObject, AVAudioPlayerDelegate {
    public static let shared = AdhanPlayerService()
    
    private var audioPlayer: AVAudioPlayer?
    
    private override init() {
        super.init()
        setupRemoteCommandCenter()
    }
    
    public func playAdhan(prayerName: String? = nil) {
        // Stop any existing playback first
        stop()
        
        let isFajr = prayerName?.lowercased() == "fajr"
        let fileName = isFajr ? "adhan_fajr" : "adhan"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Adhan") else {
            print("❌ Adhan file not found: \(fileName)")
            return
        }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
            try session.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            print("🔊 Playing Adhan: \(fileName) in foreground/background")
            updateNowPlaying(title: "Adhan", artist: isFajr ? "Fajr" : "Standard")
        } catch {
            print("❌ Error configuring audio session or playing adhan: \(error)")
        }

    }
    
    public func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        try? AVAudioSession.sharedInstance().setActive(false)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] _ in
            self.audioPlayer?.play()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            self.stop()
            return .success
        }
        
        commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget { [unowned self] _ in
            self.stop()
            return .success
        }
    }
    
    private func updateNowPlaying(title: String, artist: String) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        
        if let player = audioPlayer {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // MARK: - AVAudioPlayerDelegate
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}
