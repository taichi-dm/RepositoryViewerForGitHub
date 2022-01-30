//
//  GitHubSearchResponse.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Foundation

struct GitHubSearchResponse: Codable {
    var items: [Repository]?
}
