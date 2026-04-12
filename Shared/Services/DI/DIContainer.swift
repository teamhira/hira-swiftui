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
    public let logger: Logger
    public let keychainService: KeychainService
    public let userDefaultsService: UserDefaultsService
    public lazy var recitationManager: any RecitationManager = RecitationManagerImpl(repository: audioRepository)
    
    public lazy var quranStorage: QuranStorage = QuranStorageImpl()
    public lazy var databaseService: DatabaseService = SwiftDataService()
    
    // APIs
    public lazy var quranAPI = QuranAPI(client: foundationClient)
    public lazy var audioAPI = AudioAPI(client: foundationClient)
    public lazy var resourceAPI = ResourceAPI(client: foundationClient)
    public lazy var searchAPI = SearchAPI(client: foundationClient)
    public lazy var quranReflectAPI = QuranReflectAPI(client: foundationClient)
    
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
    
    // Use Cases
    public lazy var getSurahListUseCase: GetSurahListUseCase = GetSurahListUseCaseImpl(repository: quranRepository)
    public lazy var getAyahsByChapterUseCase: GetAyahsByChapterUseCase = GetAyahsByChapterUseCaseImpl(repository: quranRepository)
    public lazy var getSurahInfoUseCase: GetSurahInfoUseCase = GetSurahInfoUseCaseImpl(repository: quranRepository)
    public lazy var getAyahsByPageUseCase: GetAyahsByPageUseCase = GetAyahsByPageUseCaseImpl(repository: quranRepository)
    public lazy var getJuzListUseCase: GetJuzListUseCase = GetJuzListUseCaseImpl(repository: quranRepository)
    
    private init() {
        self.logger = Logger()
        self.keychainService = KeychainService()
        self.userDefaultsService = UserDefaultsService()
        self.foundationClient = FoundationClient()
    }
}

public typealias ServiceContainer = DIContainer
