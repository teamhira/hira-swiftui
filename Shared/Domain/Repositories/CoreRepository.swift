//
//  CoreRepository.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public protocol CoreRepository {
    func getCoreData(id: String) -> AnyPublisher<CoreData, Error>
    func listCoreData() -> AnyPublisher<[CoreData], Error>
}
