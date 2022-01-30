//
//  GitHubSearchRepositoriesAPI.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Alamofire
import RxSwift

/// For fetch [Repository] from given query and URL.
final internal class GitHubSearchRepositoriesAPI {

    static internal func fetchRepositories(
        from query: String,
        order: Order = .desc,
        result: @escaping (Result<[Repository], GitHubSearchRepositoriesAPIError>) -> Void
    ) {
        guard !query.isEmpty else { return }

        AF
            .request("https://api.github.com/search/repositories?q=\(query.trimmingCharacters(in: .whitespacesAndNewlines))&sort=stars&order=\(order.rawValue)")
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data,
                          let response = try? JSONDecoder().decode(GitHubSearchResponse.self, from: data),
                          let repositories = response.items
                    else {
                        result(.failure(.somethingIsWrong))
                        return
                    }

                    result(.success(repositories))
                case .failure(let afError):
                    result(.failure(.afError(afError)))
                }
            }
    }

}

/// Protocol Extension
/// Adapt to 'ReactiveCompatible' from RxSwift
extension GitHubSearchRepositoriesAPI: ReactiveCompatible {}

extension Reactive where Base: GitHubSearchRepositoriesAPI {

    /// Convert the completion handled method to Observable<[Repository]> (maybe it's RxSwift's things.)
    static func fetchRepositories(from query: String, order: Order = .desc) -> Observable<[Repository]> {
        Observable.create { observer in
            GitHubSearchRepositoriesAPI.fetchRepositories(from: query, order: .desc) { result in
                switch result {
                case .success(let repositories):
                    observer.onNext(repositories)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.share(replay: 1, scope: .whileConnected)
    }

}
