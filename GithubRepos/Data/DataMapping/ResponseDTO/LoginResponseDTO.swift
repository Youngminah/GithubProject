//
//  LoginResponseDTO.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation

struct LoginResponseDTO: Decodable {

    let accessToken, tokenType, scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}

extension LoginResponseDTO {

    func toDomain() -> LoginInfo {
        return .init(
            accessToken: accessToken,
            tokenType: tokenType,
            scope: scope
        )
    }
}
