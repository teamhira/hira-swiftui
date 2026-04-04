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
    case graphQLError([String])
    case unauthorized
    case serverError(String)
}
