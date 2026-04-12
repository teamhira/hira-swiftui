//
//  FootnoteResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct FootnoteResponse: Codable {
    public let footnote: FootnoteData
    
    public struct FootnoteData: Codable {
        public let id: Int
        public let text: String
        public let languageName: String?
        
        enum CodingKeys: String, CodingKey {
            case id, text
            case languageName = "language_name"
        }
    }
}
