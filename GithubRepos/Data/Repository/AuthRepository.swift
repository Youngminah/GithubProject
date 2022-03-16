//
//  AuthRepository.swift
//  GithubRepos
//
//  Created by meng on 2022/03/17.
//

import Foundation
import Moya

final class AuthRepository: AuthRepositoryType {

    let provider: MoyaProvider<AuthTarget>
    init() { provider = MoyaProvider<AuthTarget>() }
}

extension AuthRepository {

    func requestToken(
        clientID: String,
        clientSecret: String,
        code: String,
        completion: @escaping (Result<LoginInfo, GithubServerError>) -> Void
    ) {
        let parameters = ["client_id": clientID,
                          "client_secret": clientSecret,
                          "code": code]
        provider.request(.login(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                let data = try? JSONDecoder().decode(LoginResponseDTO.self, from: response.data)
                completion(.success(data!.toDomain()))
            case .failure(let error):
                completion(.failure(GithubServerError(rawValue: error.response?.statusCode ?? -1) ?? .unknown))
            }

        }
    }
}
