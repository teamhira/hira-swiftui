//
//  AllahNamesViewModel.swift
//  Hira
//
//  Created by Ryuk on 26/04/26.
//

import SwiftUI
import Observation
import Combine

@Observable
public final class AllahNamesViewModel {
    
    // MARK: - Properties
    private let repository: UmmahAsmaRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    public var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    public var isLoading: Bool = false
    public var errorMessage: String?
    
    // MARK: - Data
    public var dailyName: AsmaNameEntity?
    public var allNames: [AsmaNameEntity] = []
    public var searchResults: [AsmaNameEntity] = []
    
    private let searchSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initialization
    public init(repository: UmmahAsmaRepository = DIContainer.shared.ummahAsmaRepository) {
        self.repository = repository
        setupSearch()
        loadCachedData()
    }
    
    // MARK: - Logic
    public func fetchInitialData() {
        let lastFetch = UserDefaults.standard.double(forKey: "HIRA_ASMA_LAST_FETCH")
        let today = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        
        if lastFetch < today || allNames.isEmpty || dailyName == nil {
            fetchAllNames()
            fetchDailyName()
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "HIRA_ASMA_LAST_FETCH")
        }
    }
    
    public func fetchAllNames() {
        isLoading = true
        repository.listNames()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                let items = response.data.names.map { $0.toDomain() }
                self?.allNames = items
                self?.saveAllToCache(items)
            }
            .store(in: &cancellables)
    }
    
    public func fetchDailyName() {
        repository.getDailyRecitation()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                let item = response.data.toDomain()
                self?.dailyName = item
                self?.saveDailyToCache(item)
            }
            .store(in: &cancellables)
    }
    
    private func setupSearch() {
        searchSubject
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                if query.count >= 2 {
                    self?.performSearch(query: query)
                } else if query.isEmpty {
                    self?.searchResults = []
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        isLoading = true
        repository.searchNames(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.searchResults = response.data.results.map { $0.toDomain() }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Caching
    private func saveAllToCache(_ data: [AsmaNameEntity]) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_ASMA_ALL_CACHE")
        }
    }
    
    private func saveDailyToCache(_ data: AsmaNameEntity) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_ASMA_DAILY_CACHE")
        }
    }
    
    private func loadCachedData() {
        if let data = UserDefaults.standard.data(forKey: "HIRA_ASMA_ALL_CACHE"),
           let cached = try? JSONDecoder().decode([AsmaNameEntity].self, from: data) {
            self.allNames = cached
        }
        
        if let data = UserDefaults.standard.data(forKey: "HIRA_ASMA_DAILY_CACHE"),
           let cached = try? JSONDecoder().decode(AsmaNameEntity.self, from: data) {
            self.dailyName = cached
        }
    }
}
