//
//  NetworkError.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case unauthorized
    case forbidden
    case serverError(String)
    case authenticationRequired
    case refreshTokenFailed
}
