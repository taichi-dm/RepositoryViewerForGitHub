//
//  Repository.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let updatedAtString: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case updatedAtString = "updated_at"
    }
}


// MARK: - Computed Properties
extension Repository {

    /// Describes url
    /// fullName describes "\(username)/\(repositoryName)"
    var urlString: String { "https://github.com/\(fullName)" }

}
