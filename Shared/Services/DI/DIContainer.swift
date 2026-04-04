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
    public let graphQLService: GraphQLService
    public let authService: AuthService
    public let logger: Logger
    public let keychainService: KeychainService
    public let userDefaultsService: UserDefaultsService
    
    // Repositories
    public let authRepository: AuthRepository
    public let quranRepository: QuranRepository
    public let downloadRepository: DownloadRepository
    public let coreRepository: CoreRepository
    
    // Use Cases
    public lazy var getUserUseCase = GetUserUseCase(repository: authRepository)
    public lazy var getSurahListUseCase = GetSurahListUseCase(repository: quranRepository)
    public lazy var downloadSurahUseCase = DownloadSurahUseCase(repository: downloadRepository)
    public lazy var syncOfflineDataUseCase = SyncOfflineDataUseCase(repository: quranRepository)
    public lazy var listCoreDataUseCase = ListCoreDataUseCase(repository: coreRepository)
    
    private init() {
        self.graphQLService = GraphQLService()
        self.logger = Logger()
        self.keychainService = KeychainService()
        self.userDefaultsService = UserDefaultsService()
        
        let client = GraphQLClient(url: AppConfig.graphqlURL)
        
        self.authRepository = AuthRepositoryImpl(client: client)
        self.quranRepository = QuranRepositoryImpl(client: client)
        self.downloadRepository = DownloadRepositoryImpl()
        self.coreRepository = CoreRepositoryImpl(client: client)
        
        self.authService = AuthService(repository: authRepository)
    }
}

public typealias ServiceContainer = DIContainer
