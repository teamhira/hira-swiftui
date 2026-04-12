//
//  GetJuzListUseCase.swift
//  Hira
//
//  Created by Ryuk on 12/04/26.
//

import Foundation
import Combine

public protocol GetJuzListUseCase {
    func execute() -> AnyPublisher<[JuzResponse], Error>
}

public class GetJuzListUseCaseImpl: GetJuzListUseCase {
    private let repository: QuranRepository
    
    public init(repository: QuranRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<[JuzResponse], Error> {
        return repository.getJuzs()
    }
}
