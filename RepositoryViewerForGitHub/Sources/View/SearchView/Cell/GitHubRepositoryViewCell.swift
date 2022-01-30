//
//  GitHubRepositoryViewCell.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import UIKit

final class GitHubRepositoryViewCell: UITableViewCell {
    // MARK: - 📕
    @IBOutlet private weak var repositoryIcon: UIImageView! {
        didSet {
            repositoryIcon.tintColor = .systemGray2
        }
    }

    // MARK: - Title
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }

    // MARK: - Description
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = .systemGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }

    // MARK: - ⭐️
    @IBOutlet private weak var stargazerImage: UIImageView! {
        didSet {
            stargazerImage.tintColor = .systemGray2
        }
    }

    // MARK: - Stargazer Count
    @IBOutlet private weak var stargazerCountLabel: UILabel! {
        didSet {
            stargazerCountLabel.textColor = .systemGray2
            stargazerCountLabel.font = .systemFont(ofSize: 11, weight: .semibold)
            // .monospacedDigitSystemFont(ofSize: 11, weight: .semibold)
        }
    }

    // MARK: - Method in order to assign repository datas.
    func prepareUI(gitHubModel: Repository) {
        titleLabel.text = gitHubModel.name
        descriptionLabel.text = gitHubModel.description
        stargazerCountLabel.text = "\(gitHubModel.stargazersCount.withComma) stars"

        let isStargazerHidden = gitHubModel.stargazersCount == .zero
        stargazerImage.isHidden = isStargazerHidden
        stargazerCountLabel.isHidden = isStargazerHidden
    }

}
