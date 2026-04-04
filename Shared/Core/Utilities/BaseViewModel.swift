//
//  BaseViewModel.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation
import Combine

public enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(Error)
}

@Observable
public class BaseViewModel {
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
    internal var cancellables = Set<AnyCancellable>()
    
    public init() {}
}
