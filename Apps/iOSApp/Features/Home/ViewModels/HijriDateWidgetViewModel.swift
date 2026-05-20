//
//  HijriDateWidgetViewModel.swift
//  Hira
//
//  Created by Ryuk on 03/04/26.
//

import Foundation
import Combine
import SwiftUI

class HijriDateWidgetViewModel: ObservableObject {
    @Published var hijriDate: HijriDate?
    @Published var gregorianDate: GregorianDate?
    @Published var islamicInfo: UmmahIslamicInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getTodayHijriUseCase: GetTodayHijriUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getTodayHijriUseCase: GetTodayHijriUseCase = DIContainer.shared.getTodayHijriUseCase) {
        self.getTodayHijriUseCase = getTodayHijriUseCase
        fetchHijriDate()
    }
    
    func fetchHijriDate() {
        isLoading = true
        getTodayHijriUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.hijriDate = response.data.hijri.toDomain()
                self?.gregorianDate = response.data.gregorian.toDomain()
                self?.islamicInfo = response.data.islamicInfo?.toDomain()
            }
            .store(in: &cancellables)
    }
}
