//
//  SearchViewModel.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import RxSwift
import RxCocoa

protocol GithubSearchViewModelInput {
    var searchTextObserver: AnyObserver<String> { get }
}

protocol GithubSearchViewModelOutput {
    var changeModelsObservable: Observable<Void> { get }
    var repositories: [Repository] { get }
}

final class GithubSearchViewModel: GithubSearchViewModelInput, GithubSearchViewModelOutput {

    let disposeBag = DisposeBag()
    private let _searchText = PublishRelay<String>()
    lazy var searchTextObserver: AnyObserver<String> = .init(eventHandler: { event in
        guard let element = event.element else { return }
        self._searchText.accept(element)
    })

    private let _changeModelsObservable = PublishRelay<Void>()
    lazy var changeModelsObservable = _changeModelsObservable.asObservable()
    private(set) var repositories: [Repository] = []

    init() {
        _searchText
            .asObservable()
            .flatMap { searchWord -> Observable<[Repository]> in
                GitHubSearchRepositoriesAPI.rx.fetchRepositories(from: searchWord)
            }
            .map({ [weak self] repositories -> Void in
                self?.repositories = repositories
                return
            })
            .bind(to: _changeModelsObservable)
            .disposed(by: disposeBag)
    }

}
