//
//  ReposResponseDTO.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import Foundation

struct ReposResponseDTO: Decodable {

    let items: [RepoItemDTO]
}

extension ReposResponseDTO {

    func toDomain() -> Repos {
        return .init(items: items.map { $0.toDomain() })
    }
}

struct RepoItemDTO: Decodable {

    enum CodingKeys: String, CodingKey {
        case id, description, topics, language
        case fullName = "full_name"
        case star = "stargazers_count"
        case fork = "forks_count"
        case updatedAt = "updated_at"
    }

    let id: Int
    let fullName: String
    let description: String?
    let topics: [String]?
    let star: Int
    let fork: Int
    let language: String?
    let updatedAt: String
}

extension RepoItemDTO {

    func toDomain() -> RepoItem {
        return .init(
            id: id,
            fullName: fullName,
            description: description,
            topics: topics,
            star: star,
            fork: fork,
            language: language,
            updatedAt: updatedAt.toDate
        )
    }
}

extension String {

    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)!
        return date
    }
}

extension Date {

    func getElapsedInterval() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")

        let interval = calendar.dateComponents([.year, .month, .day], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "Update \(year)" + " " + "year ago" :
                "Update \(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "Update \(month)" + " " + "month ago" :
                "Update \(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "Update \(day)" + " " + "day ago" :
                "Update \(day)" + " " + "days ago"
        } else {
            return "Update a moment ago"
        }
    }
}
