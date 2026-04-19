//
//  DIContainer.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public class DIContainer {
    public static let shared = DIContainer()
    
    // Services
    public let foundationClient: FoundationClient
    public let membersClient: FoundationClient
    public let logger: Logger
    public let keychainService: KeychainService
    public let userDefaultsService: UserDefaultsService
    public let oauthService: OAuthService
    public let tokenManager: TokenManager
    public lazy var recitationManager: any RecitationManager = RecitationManagerImpl(repository: audioRepository)
    
    public lazy var quranStorage: QuranStorage = QuranStorageImpl()
    public lazy var databaseService: DatabaseService = SwiftDataService()
    
    // APIs
    public lazy var quranAPI = QuranAPI(client: foundationClient)
    public lazy var audioAPI = AudioAPI(client: foundationClient)
    public lazy var resourceAPI = ResourceAPI(client: foundationClient)
    public lazy var searchAPI = SearchAPI(client: foundationClient)
    public lazy var quranReflectAPI = QuranReflectAPI(client: foundationClient)
    public lazy var bookmarksAPI = BookmarksAPI(client: membersClient)
    public lazy var readingSessionsAPI = ReadingSessionsAPI(client: membersClient)
    public lazy var activityDaysAPI = ActivityDaysAPI(client: membersClient)
    
    // Repositories
    public lazy var quranRepository: QuranRepository = QuranRepositoryImpl(
        api: quranAPI,
        storage: quranStorage,
        database: databaseService
    )
    
    public lazy var audioRepository: AudioRepository = AudioRepositoryImpl(
        api: audioAPI,
        database: databaseService
    )
    
    public lazy var resourceRepository: ResourceRepository = ResourceRepositoryImpl(
        api: resourceAPI,
        database: databaseService
    )
    
    public lazy var searchRepository: SearchRepository = SearchRepositoryImpl(
        api: searchAPI
    )
    
    public lazy var quranReflectRepository: QuranReflectRepository = QuranReflectRepositoryImpl(
        api: quranReflectAPI
    )
    
    public lazy var bookmarkRepository: BookmarkRepository = BookmarkRepositoryImpl(
        api: bookmarksAPI
    )
    
    public lazy var readingSessionRepository: ReadingSessionRepository = ReadingSessionRepositoryImpl(
        api: readingSessionsAPI
    )

    public lazy var activityDayRepository: ActivityDayRepository = ActivityDayRepositoryImpl(
        api: activityDaysAPI
    )
    
    // Use Cases
    public lazy var getSurahListUseCase: GetSurahListUseCase = GetSurahListUseCaseImpl(repository: quranRepository)
    public lazy var getAyahsByChapterUseCase: GetAyahsByChapterUseCase = GetAyahsByChapterUseCaseImpl(repository: quranRepository)
    public lazy var getSurahInfoUseCase: GetSurahInfoUseCase = GetSurahInfoUseCaseImpl(repository: quranRepository)
    public lazy var getAyahsByPageUseCase: GetAyahsByPageUseCase = GetAyahsByPageUseCaseImpl(repository: quranRepository)
    public lazy var getJuzListUseCase: GetJuzListUseCase = GetJuzListUseCaseImpl(repository: quranRepository)
    public lazy var getBookmarksUseCase: GetBookmarksUseCase = GetBookmarksUseCaseImpl(repository: bookmarkRepository)
    public lazy var getBookmarksAyahsRangeUseCase: GetBookmarksAyahsRangeUseCase = GetBookmarksAyahsRangeUseCaseImpl(repository: bookmarkRepository)
    public lazy var addBookmarkUseCase: AddBookmarkUseCase = AddBookmarkUseCaseImpl(repository: bookmarkRepository)
    public lazy var deleteBookmarkUseCase: DeleteBookmarkUseCase = DeleteBookmarkUseCaseImpl(repository: bookmarkRepository)
    public lazy var getReadingSessionsUseCase: GetReadingSessionsUseCase = GetReadingSessionsUseCaseImpl(repository: readingSessionRepository)
    public lazy var addReadingSessionUseCase: AddReadingSessionUseCase = AddReadingSessionUseCaseImpl(repository: readingSessionRepository)
    public lazy var getActivityDaysUseCase: GetActivityDaysUseCase = GetActivityDaysUseCaseImpl(repository: activityDayRepository)
    public lazy var addActivityDayUseCase: AddActivityDayUseCase = AddActivityDayUseCaseImpl(repository: activityDayRepository)
    
    private init() {
        self.logger = Logger()
        self.keychainService = KeychainService()
        self.userDefaultsService = UserDefaultsService()
        self.foundationClient = FoundationClient(baseURL: AppConfig.foundationBaseURL.appendingPathComponent(FoundationEndpoints.contentPath))
        self.membersClient = FoundationClient(baseURL: AppConfig.foundationBaseURL.appendingPathComponent(FoundationEndpoints.authPath))
        self.tokenManager = TokenManager.shared
        self.oauthService = OAuthService()
    }
}

public typealias ServiceContainer = DIContainer
