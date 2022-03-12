//
//  UserInfoResponseDTO.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct UserInfoResponseDTO: Decodable {

    enum CodingKeys: String, CodingKey {
        case company, name, location, followers, following
        case userId = "login"
        case avatarUrl = "avatar_url"
    }

    let avatarUrl: String?
    let userId: String
    let name: String
    let company: String?
    let location: String?
    let followers: Int
    let following: Int
}

extension UserInfoResponseDTO {

    func toDomain() -> UserInfo {
        return .init(
            avatarUrl: avatarUrl,
            userId: userId,
            name: name,
            company: company,
            location: location,
            followers: followers,
            following: following
        )
    }
}
