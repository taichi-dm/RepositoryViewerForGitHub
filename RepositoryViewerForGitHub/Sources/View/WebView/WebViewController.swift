//
//  WebViewController.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import UIKit
import WebKit

final class GitHubWebViewController: UIViewController, WKNavigationDelegate {

    private var repository: Repository?
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: repository?.urlString ?? "https://github.co.jp/") {
            self.webView.load(URLRequest(url: url))
        }
    }

    func setRepository(_ repository: Repository) {
        self.repository = repository
    }

}
