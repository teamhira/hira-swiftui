//
//  DuaViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import Observation
import Combine

// MARK: - ViewModel
@Observable
class DuaViewModel {
    
    // MARK: - Dependencies
    private let getDuaCategoriesUseCase: GetDuaCategoriesUseCase
    private let getDuasByCategoryUseCase: GetDuasByCategoryUseCase
    private let getRandomDuaUseCase: GetRandomDuaUseCase
    private let searchDuasUseCase: SearchDuasUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    // MARK: - State
    var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    private let searchSubject = PassthroughSubject<String, Never>()
    
    var selectedCategory: String = "dua_category_all"
    
    var categories: [DuaCategoryEntity] = []
    var searchResults: [DuaEntity] = []
    var duas: [DuaEntity] = []
    var featuredDua: DuaEntity?
    
    var isLoading: Bool = false
    var isCategoriesLoading: Bool = false
    var isFeaturedLoading: Bool = false
    var isSearching: Bool = false
    
    // MARK: - Init
    init(
        getDuaCategoriesUseCase: GetDuaCategoriesUseCase = DIContainer.shared.getDuaCategoriesUseCase,
        getDuasByCategoryUseCase: GetDuasByCategoryUseCase = DIContainer.shared.getDuasByCategoryUseCase,
        getRandomDuaUseCase: GetRandomDuaUseCase = DIContainer.shared.getRandomDuaUseCase,
        searchDuasUseCase: SearchDuasUseCase = DIContainer.shared.searchDuasUseCase
    ) {
        self.getDuaCategoriesUseCase = getDuaCategoriesUseCase
        self.getDuasByCategoryUseCase = getDuasByCategoryUseCase
        self.getRandomDuaUseCase = getRandomDuaUseCase
        self.searchDuasUseCase = searchDuasUseCase
        
        loadCachedData()
        setupSearch()
        fetchInitialData()
    }
    
    // MARK: - Actions
    func fetchInitialData() {
        // Only fetch if not fetched today or if caches are empty
        let lastDate = UserDefaults.standard.object(forKey: "HIRA_DUA_LAST_FETCH") as? Date ?? Date.distantPast
        let isToday = Calendar.current.isDateInToday(lastDate)
        
        if !isToday || categories.isEmpty {
            fetchCategories()
        }
        
        if !isToday || featuredDua == nil {
            fetchFeaturedDua()
        }
        
        if !isToday {
            UserDefaults.standard.set(Date(), forKey: "HIRA_DUA_LAST_FETCH")
        }
    }
    
    func fetchCategories() {
        isCategoriesLoading = true
        getDuaCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isCategoriesLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching categories: \(error)")
                }
            } receiveValue: { [weak self] response in
                let categories = response.data.categories.map { $0.toDomain() }
                self?.categories = categories
                self?.saveCategoriesToCache(categories)
            }
            .store(in: &cancellables)
    }
    
    func fetchFeaturedDua() {
        isFeaturedLoading = true
        getRandomDuaUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFeaturedLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching random dua: \(error)")
                }
            } receiveValue: { [weak self] response in
                let dua = response.data.toDomain()
                self?.featuredDua = dua
                self?.saveFeaturedToCache(dua)
            }
            .store(in: &cancellables)
    }
    
    func fetchDuasByCategory(_ categoryId: String) {
        if categoryId == "dua_category_all" {
            self.duas = []
            return
        }
        
        isLoading = true
        getDuasByCategoryUseCase.execute(id: categoryId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching duas by category: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.duas = response.data.duas.map { $0.toDomain() }
            }
            .store(in: &cancellables)
    }
    
    private func setupSearch() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
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
        isSearching = true
        searchDuasUseCase.execute(query: query, category: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSearching = false
                if case .failure(let error) = completion {
                    print("Error searching duas: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.searchResults = response.data.results.map { $0.toDomain() }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Caching
    private func saveCategoriesToCache(_ data: [DuaCategoryEntity]) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_DUA_CATEGORIES_CACHE")
        }
    }
    
    private func saveFeaturedToCache(_ data: DuaEntity) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "HIRA_DUA_FEATURED_CACHE")
        }
    }
    
    private func loadCachedData() {
        if let data = UserDefaults.standard.data(forKey: "HIRA_DUA_CATEGORIES_CACHE"),
           let cached = try? JSONDecoder().decode([DuaCategoryEntity].self, from: data) {
            self.categories = cached
        }
        
        if let data = UserDefaults.standard.data(forKey: "HIRA_DUA_FEATURED_CACHE"),
           let cached = try? JSONDecoder().decode(DuaEntity.self, from: data) {
            self.featuredDua = cached
        }
    }
    
    // MARK: - Helpers
    func getIconForCategory(_ id: String) -> String {
        switch id {
        case "morning": return "sun.and.horizon.fill"
        case "evening": return "moon.stars.fill"
        case "wudu": return "drop.fill"
        case "prayer": return "person.fill"
        case "after_prayer": return "hand.raised.fill"
        case "sleep": return "bed.double.fill"
        case "food": return "fork.knife"
        case "travel": return "airplane"
        case "home": return "house.fill"
        case "masjid": return "building.columns.fill"
        case "distress": return "heart.text.square.fill"
        case "forgiveness": return "leaf.fill"
        case "illness": return "cross.case.fill"
        case "weather": return "cloud.rain.fill"
        case "knowledge": return "book.fill"
        case "parents": return "figure.2.and.child.holdinghands"
        case "guidance": return "compass.drawing"
        case "gratitude": return "hands.clap.fill"
        case "protection": return "shield.fill"
        case "dhikr": return "circle.dotted"
        case "marriage": return "figure.2.arms.open"
        case "hajj": return "square.fill"
        case "grief": return "cloud.fog.fill"
        case "children": return "figure.child"
        case "business": return "briefcase.fill"
        case "night_prayer": return "moon.fill"
        case "quran_recitation": return "book.closed.fill"
        default: return "square.grid.2x2.fill"
        }
    }
}
