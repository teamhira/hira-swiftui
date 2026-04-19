//
//  QuranViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation
import Combine

@Observable
public class QuranViewModel: BaseViewModel {
    let getSurahListUseCase: GetSurahListUseCase
    let getAyahsByChapterUseCase: GetAyahsByChapterUseCase
    let getSurahInfoUseCase: GetSurahInfoUseCase
    let getAyahsByPageUseCase: GetAyahsByPageUseCase
    let getJuzListUseCase: GetJuzListUseCase
    let getBookmarksUseCase: GetBookmarksUseCase
    let getBookmarksAyahsRangeUseCase: GetBookmarksAyahsRangeUseCase
    let addBookmarkUseCase: AddBookmarkUseCase
    let deleteBookmarkUseCase: DeleteBookmarkUseCase
    let getReadingSessionsUseCase: GetReadingSessionsUseCase
    let addReadingSessionUseCase: AddReadingSessionUseCase
    let getActivityDaysUseCase: GetActivityDaysUseCase
    let addActivityDayUseCase: AddActivityDayUseCase
    let resourceRepository: ResourceRepository
    public var recitationManager: any RecitationManager
    let audioRepository: AudioRepository
    let logger = Logger()
    
    public var selectedBottomTab: QuranBottomTab = .surah
    public var selectedTopTab: QuranTopTab = .surah
    public var searchQuery: String = ""
    public var showingHistory: Bool = false
    public var toastMessage: String? = nil
    
    // Auto Scroll State
    @ObservationIgnored var autoScrollTimer: Timer?
    @ObservationIgnored var activeAyahDurationMs: Double = 0
    @ObservationIgnored var activeAyahElapsedMs: Double = 0
    @ObservationIgnored var autoScrollTimestamps: [AudioTimestampModel] = []
    
    // Bookmark Debounce State
    @ObservationIgnored var bookmarkTimers: [String: Timer] = [:]
    public var optimisticBookmarks: Set<String> = []
    var bookmarkedAyahIds: [String: String] = [:]
    
    // Reading Session State
    public var readingSessions: [ReadingSessionEntity] = []
    public var isFetchingReadingSessions: Bool = false
    public var isRedirectedFromBookmark: Bool = false

    // Activity Day State
    public var activityDays: [ActivityDayEntity] = []
    public var isFetchingActivityDays: Bool = false
    
    @ObservationIgnored var readingSessionFirstPostTimer: Timer?
    @ObservationIgnored var readingSessionDebounceTimer: Timer?
    @ObservationIgnored var hasFulfilledFirstMinute: Bool = false
    @ObservationIgnored var lastRecordedAyah: (surah: Int, ayah: Int)?

    // Activity Day Tracking State
    @ObservationIgnored var activityDayTimer: Timer?
    @ObservationIgnored var activityDaySessionStart: Date?
    @ObservationIgnored var activityDayElapsedSeconds: Int = 0
    @ObservationIgnored var activityDayReadRanges: [String] = []
    @ObservationIgnored var activityDayCurrentAyah: (surah: Int, ayah: Int)?
    
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
    
    public var bookmarks: [QuranBookmark] = []
    public var readingBookmark: BookmarkEntity?
    public var bookmarksPagination: BookmarkPagination?
    public var isFetchingBookmarks: Bool = false
    
    public var history: [QuranHistoryItem] = []
    
    public var dailyReminders: [DailyReminder] = [
        DailyReminder(title: "Morning Dhikr", description: "And it is He who sends down rain from heaven, and We produce thereby the vegetation of every kind", reference: "Al-An'am 6:99", arabicText: "وَهُوَ ٱلَّذِىٓ أَنzَلَ مِنَ ٱلسَّمَآءِ مَآءًۭ فَأَخْرَجْنَا بِهِۦ نَبَاتَ كُلِّ شَىْءٍۭ", time: "05:00 AM", likes: 123, bookmarks: 123, shares: 123, image: "morning_dhikr_bg")
    ]
    
    // MARK: - Initiation
    
    public init(
        getSurahListUseCase: GetSurahListUseCase = ServiceContainer.shared.getSurahListUseCase,
        getAyahsByChapterUseCase: GetAyahsByChapterUseCase = ServiceContainer.shared.getAyahsByChapterUseCase,
        getSurahInfoUseCase: GetSurahInfoUseCase = ServiceContainer.shared.getSurahInfoUseCase,
        getAyahsByPageUseCase: GetAyahsByPageUseCase = ServiceContainer.shared.getAyahsByPageUseCase,
        getJuzListUseCase: GetJuzListUseCase = ServiceContainer.shared.getJuzListUseCase,
        getBookmarksUseCase: GetBookmarksUseCase = ServiceContainer.shared.getBookmarksUseCase,
        getBookmarksAyahsRangeUseCase: GetBookmarksAyahsRangeUseCase = ServiceContainer.shared.getBookmarksAyahsRangeUseCase,
        addBookmarkUseCase: AddBookmarkUseCase = ServiceContainer.shared.addBookmarkUseCase,
        deleteBookmarkUseCase: DeleteBookmarkUseCase = ServiceContainer.shared.deleteBookmarkUseCase,
        getReadingSessionsUseCase: GetReadingSessionsUseCase = ServiceContainer.shared.getReadingSessionsUseCase,
        addReadingSessionUseCase: AddReadingSessionUseCase = ServiceContainer.shared.addReadingSessionUseCase,
        getActivityDaysUseCase: GetActivityDaysUseCase = ServiceContainer.shared.getActivityDaysUseCase,
        addActivityDayUseCase: AddActivityDayUseCase = ServiceContainer.shared.addActivityDayUseCase,
        resourceRepository: ResourceRepository = ServiceContainer.shared.resourceRepository,
        recitationManager: any RecitationManager = ServiceContainer.shared.recitationManager,
        audioRepository: AudioRepository = ServiceContainer.shared.audioRepository
    ) {
        self.getSurahListUseCase = getSurahListUseCase
        self.getAyahsByChapterUseCase = getAyahsByChapterUseCase
        self.getSurahInfoUseCase = getSurahInfoUseCase
        self.getAyahsByPageUseCase = getAyahsByPageUseCase
        self.getJuzListUseCase = getJuzListUseCase
        self.getBookmarksUseCase = getBookmarksUseCase
        self.getBookmarksAyahsRangeUseCase = getBookmarksAyahsRangeUseCase
        self.addBookmarkUseCase = addBookmarkUseCase
        self.deleteBookmarkUseCase = deleteBookmarkUseCase
        self.getReadingSessionsUseCase = getReadingSessionsUseCase
        self.addReadingSessionUseCase = addReadingSessionUseCase
        self.getActivityDaysUseCase = getActivityDaysUseCase
        self.addActivityDayUseCase = addActivityDayUseCase
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
        self.getBookmarksUseCase = DIContainer.shared.getBookmarksUseCase
        self.getBookmarksAyahsRangeUseCase = DIContainer.shared.getBookmarksAyahsRangeUseCase
        self.addBookmarkUseCase = DIContainer.shared.addBookmarkUseCase
        self.deleteBookmarkUseCase = DIContainer.shared.deleteBookmarkUseCase
        self.getReadingSessionsUseCase = DIContainer.shared.getReadingSessionsUseCase
        self.addReadingSessionUseCase = DIContainer.shared.addReadingSessionUseCase
        self.getActivityDaysUseCase = DIContainer.shared.getActivityDaysUseCase
        self.addActivityDayUseCase = DIContainer.shared.addActivityDayUseCase
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
    
    // MARK: - Internal Helpers
    
    public var filteredSurahs: [Surah] {
        if searchQuery.isEmpty {
            return surahs
        }
        return surahs.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }

    public func showToast(_ message: String) {
        toastMessage = message
        // Auto-dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.toastMessage == message {
                withAnimation {
                    self.toastMessage = nil
                }
            }
        }
    }
}
