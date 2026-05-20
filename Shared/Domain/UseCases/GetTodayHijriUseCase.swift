//
//  GetTodayHijriUseCase.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation
import Combine

public protocol GetTodayHijriUseCase {
    func execute() -> AnyPublisher<UmmahResponse<TodayHijriResponse>, Error>
}

public class GetTodayHijriUseCaseImpl: GetTodayHijriUseCase {
    private let repository: UmmahDateRepository
    
    public init(repository: UmmahDateRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<UmmahResponse<TodayHijriResponse>, Error> {
        repository.getTodayHijri()
    }
}
