//
//  HomeViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import Observation
import Combine

@Observable
public class HomeViewModel: BaseViewModel {
    private let getSurahListUseCase: GetSurahListUseCase
    
    public var surahs: [Surah] = []
    
    public init(getSurahListUseCase: GetSurahListUseCase = DIContainer.shared.getSurahListUseCase) {
        self.getSurahListUseCase = getSurahListUseCase
        super.init()
    }
    
    public func fetchSurahs() {
        isLoading = true
        getSurahListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] surahs in
                self?.surahs = surahs
            }
            .store(in: &cancellables)
    }
}
