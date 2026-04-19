//
//  QuranReflectResponse.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public struct QuranReflectFeedResponse: Codable {
    public let posts: [PostFeedItemResponse]
}

public struct QuranReflectSingleResponse: Codable {
    public let post: PostFeedItemResponse
}

public struct PostFeedItemResponse: Codable {
    public let id: Int
    public let body: String
    public let createdAt: String
    public let user: UserInfoResponse
    
    enum CodingKeys: String, CodingKey {
        case id, body, user
        case createdAt = "created_at"
    }
}

public struct UserInfoResponse: Codable {
    public let id: Int
    public let name: String
    public let username: String
    public let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, username
        case avatarUrl = "avatar_url"
    }
}
