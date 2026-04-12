//
//  QuranViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation
import Combine

public enum QuranBottomTab: String, CaseIterable {
    case surah = "quran_tab_surah"
    case topic = "quran_tab_topic"
    case daily = "quran_tab_daily"
    
    public func title(language: LanguageManager) -> String { language.localizedString(self.rawValue) }
    
    public var icon: String {
        switch self {
        case .surah: return "book.fill"
        case .topic: return "list.bullet.indent"
        case .daily: return "calendar.day.timeline.left"
        }
    }
}

// Enums for Settings
public enum QuranReadingMode: String, CaseIterable, Codable {
    case list, page
}

public enum QuranScript: String, CaseIterable, Codable {
    case uthmani = "Uthmani"
    case indopak = "Indopak"
}

public enum QuranRepetition: String, CaseIterable, Codable {
    case never = "Never"
    case once = "1 Time"
    case twice = "2 Times"
    case thrice = "3 Times"
    case indefinitely = "Indefinitely"
}

public enum QuranCompletionAction: String, CaseIterable, Codable {
    case stop = "Stop Playing"
    case repeatSura = "Repeat Sura"
    case playNext = "Play Next Sura"
}

public struct QuranAyah: Identifiable, Hashable {
    public var id: String { "\(surahNumber)_\(number)_\(isPlaceholder ? "shell" : "real")" }
    public let surahNumber: Int
    public let number: Int
    public let textArabic: String
    public let textLatin: String
    public let translation: String
    public let words: [Word]
    public let audio: VerseAudio?
    public let pageNumber: Int?
    public let juzNumber: Int?
    public let isPlaceholder: Bool
    
    // Manual Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(surahNumber)
        hasher.combine(number)
        hasher.combine(isPlaceholder)
    }
    
    public static func == (lhs: QuranAyah, rhs: QuranAyah) -> Bool {
        lhs.surahNumber == rhs.surahNumber && 
        lhs.number == rhs.number && 
        lhs.isPlaceholder == rhs.isPlaceholder
    }
    
    // Initializer from domain Ayah
    public init(from ayah: Ayah) {
        self.surahNumber = ayah.chapterId ?? Int(ayah.surahId) ?? 0
        self.number = ayah.verseNumber
        self.pageNumber = ayah.pageNumber
        self.juzNumber = ayah.juzNumber
        
        // Prefer Uthmani script; fall back to word-construction if text is missing
        if let directText = ayah.text, !directText.isEmpty {
            self.textArabic = directText
        } else {
            // Construct from words text if available (common for some translations)
            self.textArabic = ayah.words?.compactMap { $0.text }.joined(separator: " ") ?? ""
        }
        
        // First word transliteration joined, or empty
        self.textLatin = ayah.words?
            .compactMap { $0.transliteration }
            .joined(separator: " ") ?? ""
            
        self.translation = ayah.translations?.first?.text ?? ""
        self.words = ayah.words ?? []
        self.audio = ayah.audio
        self.isPlaceholder = false
    }
    
    // Legacy init for preview / static data
    public init(surahNumber: Int, number: Int, textArabic: String, textLatin: String, translation: String, words: [Word] = [], audio: VerseAudio? = nil, pageNumber: Int? = nil, juzNumber: Int? = nil, isPlaceholder: Bool = false) {
        self.surahNumber = surahNumber
        self.number = number
        self.textArabic = textArabic
        self.textLatin = textLatin
        self.translation = translation
        self.words = words
        self.audio = audio
        self.pageNumber = pageNumber
        self.juzNumber = juzNumber
        self.isPlaceholder = isPlaceholder
    }
}

public enum QuranTopTab: String, CaseIterable {
    case surah = "quran_tab_surah"
    case juz = "quran_tab_juz"
    case bookmark = "quran_tab_bookmark"
    
    public func title(language: LanguageManager) -> String { language.localizedString(self.rawValue) }
}

public struct QuranStory: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let image: String
}

public struct QuranTopic: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let image: String
    public let storyCount: Int
}

public struct JuzProgress: Identifiable, Hashable {
    public let id: UUID
    public let number: Int
    public let surahRange: String
    public let progress: Double
    public let verseMapping: [String: String]
    
    public init(id: UUID = UUID(), number: Int, surahRange: String, progress: Double, verseMapping: [String: String]) {
        self.id = id
        self.number = number
        self.surahRange = surahRange
        self.progress = progress
        self.verseMapping = verseMapping
    }
    
    public var descriptionKey: String {
        "quran_juz_desc_\(number)"
    }
}

public struct QuranBookmark: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String
    public let surahNameArabic: String
    public let ayahNumber: Int
    public let timeAgo: String
    public let arabicText: String
}

public struct DailyReminder: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let reference: String
    public let arabicText: String
    public let time: String
    public var likes: Int
    public var bookmarks: Int
    public var shares: Int
    public let image: String
}

public struct QuranHistoryItem: Identifiable, Hashable {
    public let id = UUID()
    public let surahNumber: Int
    public let surahName: String
    public let surahNameArabic: String
    public let ayahNumber: Int
    public let date: Date
}

@Observable
public class QuranViewModel: BaseViewModel {
    private let getSurahListUseCase: GetSurahListUseCase
    private let getAyahsByChapterUseCase: GetAyahsByChapterUseCase
    private let getSurahInfoUseCase: GetSurahInfoUseCase
    private let getAyahsByPageUseCase: GetAyahsByPageUseCase
    private let getJuzListUseCase: GetJuzListUseCase
    private let resourceRepository: ResourceRepository
    public var recitationManager: any RecitationManager
    private let audioRepository: AudioRepository
    private let logger = Logger()
    
    public var selectedBottomTab: QuranBottomTab = .surah
    public var selectedTopTab: QuranTopTab = .surah
    public var searchQuery: String = ""
    public var showingHistory: Bool = false
    
    // Auto Scroll State
    @ObservationIgnored private var autoScrollTimer: Timer?
    @ObservationIgnored private var activeAyahDurationMs: Double = 0
    @ObservationIgnored private var activeAyahElapsedMs: Double = 0
    @ObservationIgnored private var autoScrollTimestamps: [AudioTimestampModel] = []
    
    public var surahs: [Surah] = []
    public var recentSurah: Surah?
    
    // Settings State
    public var theme: String = "System"
    public var textSize: CGFloat = 28
    public var readingMode: QuranReadingMode = .list
    public var keepScreenOn: Bool = false
    
    public var script: QuranScript = .uthmani
    public var showTajweed: Bool = true
    public var showWordByWord: Bool = false
    public var showWordAudio: Bool = false
    
    public var showTranslation: Bool = true
    public var selectedTranslationId: Int = 85 // Default: Abdel Haleem
    public var selectedTranslation: String {
        availableTranslations.first(where: { $0.id == selectedTranslationId })?.name ?? "Abdel Haleem"
    }
    
    public var showTransliteration: Bool = true
    public var selectedTransliteration: String = "English"
    
    public var selectedTafsirId: Int = 169 // Default: Ibn Kathir
    public var selectedTafsir: String {
        availableTafsirs.first(where: { $0.id == selectedTafsirId })?.name ?? "Ibn Kathir"
    }
    
    public var selectedLanguageCode: String = "en"
    public var selectedLanguage: String {
        availableLanguages.first(where: { $0.isoCode == selectedLanguageCode })?.name ?? "English"
    }
    
    public var audioEnabled: Bool = true
    public var selectedReciterId: Int = 7 // Default: Mishary Rashid al-`Afasy
    public var selectedReciter: String {
        availableReciters.first(where: { $0.id == selectedReciterId })?.reciterName ?? "Mishary Rashid al-`Afasy"
    }
    public var autoScroll: Bool = false
    
    // Available Resources from API
    public var availableTranslations: [TranslationResourceResponse] = []
    public var availableTafsirs: [TafsirResponse] = []
    public var availableReciters: [RecitationResponse] = []
    public var availableLanguages: [LanguageResponse] = []
    public var isLoadingResources: Bool = false
    public var isFetchingJuzs: Bool = false
    public var repetition: QuranRepetition = .never
    public var completionAction: QuranCompletionAction = .stop
    
    // UI State for Detail
    public var activeAyah: QuranAyah?
    public var selectedAyah: QuranAyah?
    public var showingAyahOptions: Bool = false
    public var showingSettings: Bool = false
    public var showingInfo: Bool = false
    public var surahInfo: SurahInfo?
    
    public var showingAutoScrollNextSurahAlert: Bool = false
    public var autoScrollNextSurah: Surah?
    
    // MARK: - Ayah Fetch State (per surah)
    
    /// In-memory store: surahNumber → fetched ayahs
    public var ayahCache: [Int: [QuranAyah]] = [:]
    /// Whether ayahs for a surah are being fetched right now
    public var isLoadingAyahs: [Int: Bool] = [:]
    
    // Page Cache (for Mushaf Mode)
    public var pageCache: [Int: [QuranAyah]] = [:]
    public var isLoadingPage: [Int: Bool] = [:]
    
    /// Last update timestamp to force UI refresh
    public var lastCacheUpdate = Date()
    
    // Mock Progress Data
    public var surahProgress: Double = 0.45
    public var khatamProgress: Double = 0.12
    
    // Other Mock Data (Stories, Topics, etc.)
    public var stories: [QuranStory] = [
        QuranStory(title: "Prophet Ibrahim's Faith", description: "The story of unwavering faith and submission to Allah", image: "story_ibrahim"),
        QuranStory(title: "The Night Journey", description: "Prophet Muhammad's miraculous journey to Jerusalem", image: "story_isra")
    ]
    
    public var topics: [QuranTopic] = [
        QuranTopic(title: "Faith & Belief", image: "topic_faith", storyCount: 12),
        QuranTopic(title: "Prayer & Worship", image: "topic_prayer", storyCount: 8),
        QuranTopic(title: "Charity & Giving", image: "topic_charity", storyCount: 6)
    ]
    
    public var juzList: [JuzProgress] = []
    
    public var bookmarks: [QuranBookmark] = [
        QuranBookmark(surahNumber: 2, surahName: "Al-Baqarah", surahNameArabic: "البقرة", ayahNumber: 255, timeAgo: "2 days", arabicText: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌۭ وَلَا نَوْمٌۭ")
    ]
    
    public var history: [QuranHistoryItem] = [
        QuranHistoryItem(surahNumber: 1, surahName: "Al-Fatihah", surahNameArabic: "الفاتحة", ayahNumber: 1, date: Date()),
        QuranHistoryItem(surahNumber: 2, surahName: "Al-Baqarah", surahNameArabic: "البقرة", ayahNumber: 285, date: Date()),
        QuranHistoryItem(surahNumber: 18, surahName: "Al-Kahf", surahNameArabic: "الكهف", ayahNumber: 10, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    ]
    
    public var dailyReminders: [DailyReminder] = [
        DailyReminder(title: "Morning Dhikr", description: "And it is He who sends down rain from heaven, and We produce thereby the vegetation of every kind", reference: "Al-An'am 6:99", arabicText: "وَهُوَ ٱلَّذِىٓ أَنzَلَ مِنَ ٱلسَّمَآءِ مَآءًۭ فَأَخْرَجْنَا بِهِۦ نَبَاتَ كُلِّ شَىْءٍۭ", time: "05:00 AM", likes: 123, bookmarks: 123, shares: 123, image: "morning_dhikr_bg")
    ]
    
    /// Returns cached ayahs for a surah, or generated shell ayahs based on verseCount.
    public func ayahs(for surah: Surah) -> [QuranAyah] {
        if let cached = ayahCache[surah.number] {
            return cached
        }
        
        // Generate shell ayahs so picker/list can render immediately
        return (1...surah.versesCount).map { i in
            QuranAyah(
                surahNumber: surah.number,
                number: i,
                textArabic: "", 
                textLatin: "",
                translation: "",
                isPlaceholder: true
            )
        }
    }
    
    public func ayahsForPage(_ page: Int) -> [QuranAyah] {
        if let cached = pageCache[page] {
            return cached
        }
        return []
    }
    
    public func isAyahsLoading(forPage page: Int) -> Bool {
        return isLoadingPage[page] ?? false
    }
    
    public func fetchPage(_ page: Int) {
        guard !isAyahsLoading(forPage: page), pageCache[page] == nil else { return }
        
        let language = selectedLanguageCode
        isLoadingPage[page] = true
        logger.debug("Fetching ayahs for page \(page) [\(language)]")
        
        let audioParam = showWordAudio ? nil : selectedReciterId
        getAyahsByPageUseCase.execute(
            pageNumber: page,
            language: language,
            translations: [selectedTranslationId],
            words: true,
            audio: audioParam
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingPage[page] = false
            if case .failure(let error) = completion {
                self.logger.error("Failed to fetch ayahs for page \(page): \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] ayahs in
            guard let self else { return }
            let models = ayahs.map { QuranAyah(from: $0) }
            self.pageCache[page] = models
            self.lastCacheUpdate = Date()
        }
        .store(in: &cancellables)
    }
    
    public func groupedAyahsForPage(_ page: Int) -> [(surahNumber: Int, ayahs: [QuranAyah])] {
        let ayahs = ayahsForPage(page)
        let dict = Dictionary(grouping: ayahs, by: { $0.surahNumber })
        return dict.keys.sorted().map { surahNumber in
            let sortedAyahs = (dict[surahNumber] ?? []).sorted(by: { $0.number < $1.number })
            return (surahNumber: surahNumber, ayahs: sortedAyahs)
        }
    }
    
    // MARK: - Fetch Ayahs
    
    public func fetchAyahs(for surah: Surah, language: String = "en") {
        let needsTajweed = showTajweed
        let hasTajweed = ayahCache[surah.number]?.contains(where: { !($0.words.first?.textTajweed ?? "").isEmpty }) ?? false
        
        // If we have cached ayahs but they lack tajweed data (and we need it), force re-fetch
        if ayahCache[surah.number] != nil && needsTajweed && !hasTajweed {
            ayahCache[surah.number] = nil
        }

        guard ayahCache[surah.number] == nil,
              isLoadingAyahs[surah.number] != true else { return }
        
        let resolvedLanguage = switch language {
        case "id": "id"
        case "ms": "ms"
        case "ar": "ar"
        default: "en"
        }
        
        _loadAyahPage(surah: surah, language: resolvedLanguage)
    }

    public func playCurrentSurah(surah: Surah) {
        // Defensive: Always ensure real data is present
        guard let cachedAyahs = ayahCache[surah.number], !cachedAyahs.isEmpty else {
            fetchAyahs(for: surah, language: selectedLanguageCode)
            return
        }

        if showWordAudio {
            // Sequential Word-by-Word logic
            let startAyah = activeAyah ?? cachedAyahs.first
            
            if let ayah = startAyah {
                self.activeAyah = ayah
                recitationManager.playWords(ayah.words)
            }
        } else {
            let verseKey = activeAyah.map { "\($0.surahNumber):\($0.number)" }
            recitationManager.playChapter(
                surahNumber: surah.number, 
                recitationId: selectedReciterId, 
                atVerseKey: verseKey
            )
        }
    }
    
    // Infinity scroll logic removed as per user request to fetch all ayahs at once
    
    private func _loadAyahPage(surah: Surah, language: String) {
        isLoadingAyahs[surah.number] = true
        logger.debug("Fetching all ayahs for surah \(surah.number) [\(language)]")
        
        // Per user request, we fetch everything at once (page 1 with large perPage)
        let audioParam = showWordAudio ? nil : selectedReciterId
        getAyahsByChapterUseCase.execute(
            chapterId: String(surah.number),
            language: language,
            page: 1,
            perPage: 300,
            words: true,
            audio: audioParam
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoadingAyahs[surah.number] = false
            if case .failure(let error) = completion {
                self.logger.error("Failed to fetch ayahs for surah \(surah.number): \(error.localizedDescription)")
                if (self.ayahCache[surah.number] ?? []).isEmpty {
                    self.errorMessage = error.localizedDescription
                }
            }
        } receiveValue: { [weak self] fetchedAyahs in
            guard let self else { return }
            let mapped = fetchedAyahs.map { QuranAyah(from: $0) }
            self.ayahCache[surah.number] = mapped
            self.lastCacheUpdate = Date()
            
            // Auto-select first ayah when loading
            if self.activeAyah == nil {
                self.activeAyah = mapped.first
            }
        }
        .store(in: &cancellables)
    }
    
    public func fetchJuzs() {
        guard juzList.isEmpty, !isFetchingJuzs else { return }
        
        isFetchingJuzs = true
        getJuzListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFetchingJuzs = false
                if case .failure(let error) = completion {
                    self?.logger.error("Failed to fetch juz list: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] juzs in
                guard let self else { return }
                // Deduplicate by juzNumber just in case API returns duplicates
                let uniqueMap = juzs.reduce(into: [Int: JuzResponse]()) { dict, juz in
                    dict[juz.juzNumber] = juz
                }
                let sortedJuzs = uniqueMap.values.sorted(by: { $0.juzNumber < $1.juzNumber })
                
                self.juzList = sortedJuzs.map { juz in
                    JuzProgress(
                        number: juz.juzNumber,
                        surahRange: self.formatJuzRange(juz.verseMapping),
                        progress: 0.0,
                        verseMapping: juz.verseMapping
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func formatJuzRange(_ mapping: [String: String]) -> String {
        // Mapping keys are surah numbers as strings
        let surahIds = mapping.keys.compactMap { Int($0) }.sorted()
        guard let firstId = surahIds.first, let lastId = surahIds.last else { return "Unknown" }
        
        let firstSurah = surahs.first(where: { $0.number == firstId })?.name ?? "Surah \(firstId)"
        let lastSurah = surahs.first(where: { $0.number == lastId })?.name ?? "Surah \(lastId)"
        
        if firstId == lastId {
            return firstSurah
        } else {
            return "\(firstSurah) - \(lastSurah)"
        }
    }
    
    public func fetchSurahInfo(id: Int, language: String) {
        logger.debug("Fetching info for surah \(id) [\(language)]")
        getSurahInfoUseCase.execute(id: String(id), language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.logger.error("Failed to fetch surah info: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] info in
                self?.surahInfo = info
            }
            .store(in: &cancellables)
    }
    
    /// Whether all ayahs are loaded for a given surah (always false now since we fetch all at once)
    public func hasMoreAyahs(for surah: Surah) -> Bool {
        return false
    }
    
    /// Whether ayahs are currently being fetched for a given surah
    public func isAyahsLoading(for surah: Surah) -> Bool {
        return isLoadingAyahs[surah.number] ?? false
    }
    
    public init(
        getSurahListUseCase: GetSurahListUseCase = ServiceContainer.shared.getSurahListUseCase,
        getAyahsByChapterUseCase: GetAyahsByChapterUseCase = ServiceContainer.shared.getAyahsByChapterUseCase,
        getSurahInfoUseCase: GetSurahInfoUseCase = ServiceContainer.shared.getSurahInfoUseCase,
        getAyahsByPageUseCase: GetAyahsByPageUseCase = ServiceContainer.shared.getAyahsByPageUseCase,
        getJuzListUseCase: GetJuzListUseCase = ServiceContainer.shared.getJuzListUseCase,
        resourceRepository: ResourceRepository = ServiceContainer.shared.resourceRepository,
        recitationManager: any RecitationManager = ServiceContainer.shared.recitationManager,
        audioRepository: AudioRepository = ServiceContainer.shared.audioRepository
    ) {
        self.getSurahListUseCase = getSurahListUseCase
        self.getAyahsByChapterUseCase = getAyahsByChapterUseCase
        self.getSurahInfoUseCase = getSurahInfoUseCase
        self.getAyahsByPageUseCase = getAyahsByPageUseCase
        self.getJuzListUseCase = getJuzListUseCase
        self.resourceRepository = resourceRepository
        self.recitationManager = recitationManager
        self.audioRepository = audioRepository
        super.init()
        setupAudioCallbacks()
    }
    
    public override init() {
        self.getSurahListUseCase = DIContainer.shared.getSurahListUseCase
        self.getAyahsByChapterUseCase = DIContainer.shared.getAyahsByChapterUseCase
        self.getSurahInfoUseCase = DIContainer.shared.getSurahInfoUseCase
        self.getAyahsByPageUseCase = DIContainer.shared.getAyahsByPageUseCase
        self.getJuzListUseCase = DIContainer.shared.getJuzListUseCase
        self.resourceRepository = DIContainer.shared.resourceRepository
        self.recitationManager = DIContainer.shared.recitationManager
        self.audioRepository = DIContainer.shared.audioRepository
        super.init()
        setupAudioCallbacks()
    }
    
    private func setupAudioCallbacks() {
        recitationManager.onVerseFinished = { [weak self] in
            DispatchQueue.main.async {
                self?.handlePlaybackFinished()
            }
        }
        recitationManager.onVerseKeyChanged = { [weak self] newKey in
            DispatchQueue.main.async {
                self?.syncActiveAyah(with: newKey)
            }
        }
        startSettingsObservation()
    }
    
    private func startSettingsObservation() {
        withObservationTracking {
            _ = self.selectedReciterId
            _ = self.showWordAudio
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.ayahCache.removeAll()
                if let surah = self.recentSurah {
                    self.fetchAyahs(for: surah, language: self.selectedLanguageCode)
                }
                self.startSettingsObservation()
            }
        }
    }
    
    private func syncActiveAyah(with verseKey: String?) {
        guard let key = verseKey else { return }
        let parts = key.split(separator: ":")
        guard parts.count == 2, let surahId = Int(parts[0]) else { return }
        
        if let ayahs = ayahCache[surahId], let matchingAyah = ayahs.first(where: { "\($0.surahNumber):\($0.number)" == key }) {
            self.activeAyah = matchingAyah
        }
    }
    
    private func handlePlaybackFinished() {
        // Only auto-next if we were playing individual word files
        guard !recitationManager.isPlayingChapter else { return }
        moveToNextAyahOptional(isTeleprompter: false)
    }
    
    private func moveToNextAyahOptional(isTeleprompter: Bool = false) {
        guard let current = activeAyah else { return }
        guard let surah = surahs.first(where: { $0.number == current.surahNumber }) else { return }
        
        let surahAyahs = ayahCache[surah.number] ?? []
        
        if let index = surahAyahs.firstIndex(where: { $0.id == current.id }) {
            if index < surahAyahs.count - 1 {
                let next = surahAyahs[index + 1]
                activeAyah = next
                
                if isTeleprompter {
                    initiateCountdown(for: surah)
                } else if showWordAudio {
                    // Auto-play the next one in WBW mode
                    playCurrentSurah(surah: surah)
                }
            } else if isTeleprompter {
                // End of surah in teleprompter mode
                if let surahIndex = surahs.firstIndex(where: { $0.number == surah.number }),
                   surahIndex < surahs.count - 1 {
                    autoScrollNextSurah = surahs[surahIndex + 1]
                    showingAutoScrollNextSurahAlert = true
                } else {
                    autoScroll = false
                }
            }
        }
    }
    
    // MARK: - Auto Scroll Teleprompter feature
    
    public func toggleAutoScroll(for surah: Surah) {
        autoScroll.toggle()
        logger.debug("Auto scroll toggled: \(autoScroll ? "ON" : "OFF")")
        
        if autoScroll {
            // ONLY start teleprompter if audio is NOT currently playing
            if recitationManager.status != .playing {
                startTeleprompter(for: surah)
            }
        } else {
            stopTeleprompter()
        }
    }
    
    public func startTeleprompter(for surah: Surah) {
        // Trigger fetch of ayahs text so we don't wait statically
        if ayahCache[surah.number] == nil {
            fetchAyahs(for: surah, language: selectedLanguageCode)
        }
        
        audioRepository.getAudioByChapter(recitationId: selectedReciterId, chapterNumber: surah.number, segments: true)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] (response: AudioFileResponse) in
                self?.autoScrollTimestamps = response.timestamps ?? []
                self?.waitForAyahsAndStart(surah: surah)
            }
            .store(in: &cancellables)
    }
    
    private func waitForAyahsAndStart(surah: Surah) {
        // If ayahs are present and no longer loading
        if let ayahs = ayahCache[surah.number], !ayahs.isEmpty, isLoadingAyahs[surah.number] != true {
            activeAyah = ayahs.first
            initiateCountdown(for: surah)
        } else {
            // Poll every 0.5s until loaded
            logger.debug("⏳ [AUTO-SCROLL] Waiting for ayahs to load for Surah \(surah.number)...")
            print("⏳ [AUTO-SCROLL] Waiting for ayahs to load for Surah \(surah.number)...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.waitForAyahsAndStart(surah: surah)
            }
        }
    }
    
    private func initiateCountdown(for surah: Surah) {
        // Find duration for the CURRENT active ayah
        if activeAyah == nil {
            activeAyah = ayahCache[surah.number]?.first
        }
        guard let current = activeAyah else { return }
        let verseKey = "\(current.surahNumber):\(current.number)"
        
        if let timestamp = autoScrollTimestamps.first(where: { $0.verseKey == verseKey }) {
            // Calculate precise duration the same way audio API defines it
            activeAyahDurationMs = timestamp.timestampTo - timestamp.timestampFrom
        } else {
            // Fallback duration if missing (e.g. 5 seconds)
            activeAyahDurationMs = 5000 
        }
        
        activeAyahElapsedMs = 0
        
        autoScrollTimer?.invalidate()
        // Fire every 500ms
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tickTeleprompter()
        }
    }
    
    private func tickTeleprompter() {
        activeAyahElapsedMs += 500
        
        if activeAyahElapsedMs >= activeAyahDurationMs {
            autoScrollTimer?.invalidate()
            moveToNextAyahOptional(isTeleprompter: true)
        }
    }
    
    private func stopTeleprompter() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    public func fetchSurahs(language: String = "en") {
        print("📡 fetchSurahs(language: \(language)) was called")
        self.isLoading = true
        self.errorMessage = nil
        logger.debug("Starting to fetch surah list for language: \(language)...")
        
        getSurahListUseCase.execute(language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                print("📡 fetchSurahs() completed for \(language) with: \(String(describing: completion))")
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.logger.error("Failed to fetch surah list (\(language)): \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] surahs in
                print("📡 fetchSurahs() received \(surahs.count) surahs for \(language)")
                self?.logger.info("Successfully fetched \(surahs.count) surahs (\(language))")
                self?.surahs = surahs
                if self?.recentSurah == nil {
                    self?.recentSurah = surahs.first
                }
            }
            .store(in: &cancellables)
    }
    
    public var filteredSurahs: [Surah] {
        if searchQuery.isEmpty {
            return surahs
        }
        return surahs.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
    public func fetchSettingsResources() {
        guard !isLoadingResources else { return }
        isLoadingResources = true
        
        let lang = selectedLanguageCode
        let language = lang == "en" ? "english" : lang // Mapper helper if needed, but repo usually handles it
        
        resourceRepository.getLanguages()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.checkLoadingFinished() } receiveValue: { [weak self] in self?.availableLanguages = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getTranslationsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.checkLoadingFinished() } receiveValue: { [weak self] in self?.availableTranslations = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getTafsirsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.checkLoadingFinished() } receiveValue: { [weak self] in self?.availableTafsirs = $0 }
            .store(in: &cancellables)
            
        resourceRepository.getRecitationsList(language: language)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.checkLoadingFinished() } receiveValue: { [weak self] in self?.availableReciters = $0 }
            .store(in: &cancellables)
    }
    
    private func checkLoadingFinished() {
        // Simplified: just turn off after some time or count, or keep it per-request
        // For now, keep isLoadingResources true until at least one finishes or similar
        isLoadingResources = false 
    }
}
