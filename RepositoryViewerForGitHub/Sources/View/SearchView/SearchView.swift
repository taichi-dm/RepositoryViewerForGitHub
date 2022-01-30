//
//  SearchView.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import RxCocoa
import RxOptional
import RxSwift
import SwiftUI
import UIKit

final internal class SearchView: UIViewController {

    @IBOutlet weak private var repositorySearchTextField: UITextField! {
        didSet {
            repositorySearchTextField.placeholder = "Search..."
            repositorySearchTextField.borderStyle = .roundedRect
        }
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let cell = UINib(nibName: "GitHubRepositoryViewCell", bundle: nil)
            tableView.register(cell, forCellReuseIdentifier: "Cell")
            tableView.rowHeight = UITableView.automaticDimension
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    private let disposeBag = DisposeBag()
    private let viewModel = GithubSearchViewModel()
    private lazy var input: GithubSearchViewModelInput = viewModel
    private lazy var output: GithubSearchViewModelOutput = viewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        repositorySearchTextField.becomeFirstResponder()

        bindInputStream()
        bindOutputStream()

        setup()

    }

    func setup() {
        navigationItem.title = "Type to Find Repository"
    }

    private func bindInputStream() {
        // 0.2以上,変化している,nilじゃない,文字数0以上だったらテキストを流す
        let searchTextObservable = repositorySearchTextField.rx.text
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .distinctUntilChanged().filterNil().filter { $0.isNotEmpty }
        
        searchTextObservable.bind(to: input.searchTextObserver).disposed(by: disposeBag)
    }

    private func bindOutputStream() {
        output
            .changeModelsObservable
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
            self.tableView.reloadData()
        }, onError: { error in
            print(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let githubModel = output.repositories[safe: indexPath.item],
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GitHubRepositoryViewCell
        else { return UITableViewCell() }
        cell.prepareUI(gitHubModel: githubModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? GitHubWebViewController
        searchVC?.setRepository(output.repositories[safe: indexPath.item]!)
        navigationController?.pushViewController(searchVC ?? SearchView(), animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookMarkAction = UIContextualAction(style: .normal, title: "ブックマーク") { action, view, completionHandler in
            do {
                guard let repository = self.output.repositories[safe: indexPath.item] else {
                    completionHandler(false)
                    return
                }
                try self.saveRepository(repository)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [bookMarkAction])
    }

    func saveRepository(_ model: Repository) throws {
        var savedBookMarks = try UserDefaults.standard.get(objectType: GitHubSearchResponse.self, forKey: "bookMarks")
        if savedBookMarks != nil {
            savedBookMarks?.items?.append(model)
            try UserDefaults.standard.set(object: savedBookMarks, forKey: "bookMarks")
        } else {
            let gitHubResponse = GitHubSearchResponse(items: [model])
            try UserDefaults.standard.set(object: gitHubResponse, forKey: "bookMarks")
        }
    }
}
