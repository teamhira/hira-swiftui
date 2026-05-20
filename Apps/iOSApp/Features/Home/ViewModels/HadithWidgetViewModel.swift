//
//  HadithWidgetViewModel.swift
//  Hira
//
//  Created by Ryuk on 21/04/26.
//

import Foundation
import Combine

class HadithWidgetViewModel: ObservableObject {
    @Published var hadith: HadithEntity?
    @Published var isLoading: Bool = false
    
    private let getRandomHadithUseCase: GetRandomHadithUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getRandomHadithUseCase: GetRandomHadithUseCase = DIContainer.shared.getRandomHadithUseCase) {
        self.getRandomHadithUseCase = getRandomHadithUseCase
        fetchRandomHadith()
    }
    
    func fetchRandomHadith() {
        isLoading = true
        
        getRandomHadithUseCase.execute(collection: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                self?.hadith = response.data.toDomain()
            }
            .store(in: &cancellables)
    }
}
