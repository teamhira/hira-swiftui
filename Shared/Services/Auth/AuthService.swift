//
//  AuthService.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public class AuthService {
    private let repository: AuthRepository
    private let tokenManager: TokenManager
    
    private var cancellables = Set<AnyCancellable>()
    @Published public var currentUser: User?
    @Published public var isAuthenticated: Bool = false
    
    public init(repository: AuthRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
        self.isAuthenticated = tokenManager.hasToken
    }
    
    public func fetchCurrentUser(id: String) {
        repository.getUser(id: id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching user: \(error)")
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    public func logout() {
        tokenManager.clearToken()
        currentUser = nil
        isAuthenticated = false
    }
}
