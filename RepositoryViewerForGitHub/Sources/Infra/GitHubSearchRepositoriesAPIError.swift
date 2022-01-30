//
//  GitHubSearchRepositoriesAPIError.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Alamofire

// Errors for GitHubSearchRepositoriesAPIError
enum GitHubSearchRepositoriesAPIError: Error {
    case somethingIsWrong
    case afError(AFError)
}
