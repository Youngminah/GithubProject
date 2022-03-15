//
//  GithubRepository.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation
import Moya

enum GithubServerError: Int, Error {

    case duplicatedError = 201
    case inValidURL = 404
    case unregisterUser = 406
    case internalServerError = 500
    case internalClientError = 501
    case unknown

    var description: String { self.errorDescription }
}

extension GithubServerError {

    var errorDescription: String {
        switch self {
        case .duplicatedError: return "201:DUPLICATE_ERROR"
        case .inValidURL: return "404:INVALID_URL_ERROR"
        case .unregisterUser: return "406:UNREGISTER_USER_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .internalClientError: return "501:INTERNAL_CLIENT_ERROR"
        default: return "UN_KNOWN_ERROR"
        }
    }
}

final class GithubRepository: GithubRepositoryType {

    let provider: MoyaProvider<GithubTarget>
    init() { provider = MoyaProvider<GithubTarget>(plugins: [MoyaCacheablePlugin()]) }
}

extension GithubRepository {

    func requestSearch(query: ReposQuery, page: Int, completion: @escaping (Result<Repos, GithubServerError>) -> Void) {
        let requestDTO = ReposRequestDTO(query: query, page: page)
        provider.request(.search(parameters: requestDTO.toDictionary)) { result in
            switch result {
            case .success(let response):
                let data = try? JSONDecoder().decode(ReposResponseDTO.self, from: response.data)
                completion(.success(data!.toDomain()))
            case .failure(let error):
                print(error)
                completion(.failure(GithubServerError(rawValue: error.response?.statusCode ?? -1) ?? .unknown))
            }
        }
    }

    func requestUserStarredRepos(owners: String, page: Int, completion: @escaping (Result<[RepoItem], GithubServerError>) -> Void) {
        let requestDTO = UserReposRequestDTO(page: page)
        provider.request(.userStarredRepos(owners: owners, parameters: requestDTO.toDictionary)) { result in
            switch result {
            case .success(let response):
                let data = try? JSONDecoder().decode([RepoItemDTO].self, from: response.data)
                completion(.success(data!.map { $0.toDomain()}))
            case .failure(let error):
                completion(.failure(GithubServerError(rawValue: error.response?.statusCode ?? -1) ?? .unknown))
            }
        }
    }

    func requestUserInfo(owners: String, completion: @escaping (Result<UserInfo, GithubServerError>) -> Void) {
        provider.request(.user(owners: owners)) { result in
            switch result {
            case .success(let response):
                let data = try? JSONDecoder().decode(UserInfoResponseDTO.self, from: response.data)
                completion(.success(data!.toDomain()))
            case .failure(let error):
                completion(.failure(GithubServerError(rawValue: error.response?.statusCode ?? -1) ?? .unknown))
            }
        }
    }

    func requestStar(repos: String, completion: @escaping (Result<Int, GithubServerError>) -> Void) {
        provider.request(.star(repos: repos)) { result in
            self.process(result: result, completion: completion)
        }
    }

    func requestUnstar(repos: String, completion: @escaping (Result<Int, GithubServerError>) -> Void) {
        provider.request(.unstar(repos: repos)) { result in
            self.process(result: result, completion: completion)
        }
    }
}

// MARK: - 응답이 필요없는 경우 제네릭 사용
extension GithubRepository {

    private func process(
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<Int, GithubServerError>) -> Void
    ) {
        switch result {
        case .success(let response):
            print(response)
            completion(.success(response.statusCode))
        case .failure(let error):
            print(error)
            completion(.failure(GithubServerError(rawValue: error.response!.statusCode) ?? .unknown))
        }
    }
}
