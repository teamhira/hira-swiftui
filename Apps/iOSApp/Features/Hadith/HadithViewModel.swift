//
//  HadithViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation
import Combine

// MARK: - ViewModel
@Observable
public final class HadithViewModel {
    
    // MARK: - Properties
    private let repository: UmmahHadithRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    public var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    public var isLoading: Bool = false
    public var isFetchingMore: Bool = false
    public var errorMessage: String?
    
    // MARK: - Data
    public var featuredHadith: HadithEntity?
    public var collections: [HadithCollectionEntity] = []
    public var hadiths: [HadithEntity] = []
    public var searchResults: [HadithEntity] = []
    
    // Pagination
    private var currentPage: Int = 1
    public var canLoadMore: Bool = true
    private var currentCollectionId: String?
    
    private let searchSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initialization
    public init(repository: UmmahHadithRepository = DIContainer.shared.ummahHadithRepository) {
        self.repository = repository
        setupSearch()
        loadCachedData()
    }
    
    // MARK: - Logic
    public func fetchInitialData() {
        let lastFetch = UserDefaults.standard.double(forKey: "HIRA_HADITH_LAST_FETCH")
        let today = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
        
        if lastFetch < today || collections.isEmpty || featuredHadith == nil {
            fetchCollections()
            fetchFeaturedHadith()
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "HIRA_HADITH_LAST_FETCH")
        }
    }
    
    public func fetchCollections() {
        isLoading = true
        repository.listCollections()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                let domainCollections = response.data.collections.map { $0.toDomain() }
                self?.collections = domainCollections
                self?.saveCollectionsToCache(domainCollections)
            }
            .store(in: &cancellables)
    }
    
    public func fetchFeaturedHadith() {
        repository.getRandomHadith(collection: nil)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                let domainHadith = response.data.toDomain()
                self?.featuredHadith = domainHadith
                self?.saveFeaturedToCache(domainHadith)
            }
            .store(in: &cancellables)
    }
    
    public func fetchHadiths(for collectionId: String, refresh: Bool = false) {
        if refresh {
            currentPage = 1
            hadiths = []
            canLoadMore = true
        }
        
        guard !isLoading && canLoadMore else { return }
        
        currentCollectionId = collectionId
        isLoading = true
        
        let targetKey = collectionId.replacingOccurrences(of: "hadith_col_", with: "")
        repository.browseCollection(collection: targetKey, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.canLoadMore = false
                }
            } receiveValue: { [weak self] response in
                let newItems = response.data.hadiths.map { $0.toDomain() }
                if refresh {
                    self?.hadiths = newItems
                } else {
                    self?.hadiths.append(contentsOf: newItems)
                }
                
                // If we got less than usual (e.g. 50), we might have reached the end
                // But the API doesn't provide total pages in current mapper, 
                // so we guess based on whether we got any items
                self?.canLoadMore = !newItems.isEmpty && newItems.count >= 20
                self?.currentPage += 1
            }
            .store(in: &cancellables)
    }
    
    public func loadMoreIfNeeded(currentItem item: HadithEntity) {
        guard let collectionId = currentCollectionId, 
              item == hadiths.last, 
              !isLoading, 
              canLoadMore else { return }
        
        fetchHadiths(for: collectionId)
    }
    
    private func setupSearch() {
        // Debounce search
        searchSubject
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                if query.count >= 3 {
                    self?.performSearch(query: query)
                } else if query.isEmpty {
                    self?.searchResults = []
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        isLoading = true
        let targetCollection = currentCollectionId?.replacingOccurrences(of: "hadith_col_", with: "")
        
        repository.searchHadiths(query: query, collection: targetCollection)
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
    private func saveCollectionsToCache(_ data: [HadithCollectionEntity]) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_HADITH_COLLECTIONS_CACHE")
        }
    }
    
    private func saveFeaturedToCache(_ data: HadithEntity) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_HADITH_FEATURED_CACHE")
        }
    }
    
    private func loadCachedData() {
        if let data = UserDefaults.standard.data(forKey: "HIRA_HADITH_COLLECTIONS_CACHE"),
           let cached = try? JSONDecoder().decode([HadithCollectionEntity].self, from: data) {
            self.collections = cached
        }
        
        if let data = UserDefaults.standard.data(forKey: "HIRA_HADITH_FEATURED_CACHE"),
           let cached = try? JSONDecoder().decode(HadithEntity.self, from: data) {
            self.featuredHadith = cached
        }
    }
    
    // MARK: - Helpers
    public func getIcon(for key: String) -> String {
        switch key {
        case "bukhari": return "books.vertical.fill"
        case "muslim": return "book.fill"
        case "abudawud": return "book.closed.fill"
        case "tirmidhi": return "character.book.closed.fill"
        case "ibnmajah": return "text.book.closed.fill"
        case "nasai": return "book.and.wrench.fill"
        case "malik": return "leaf.fill"
        default: return "book.closed.fill"
        }
    }
}
