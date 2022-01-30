//
//  Int+CommaStyle.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Foundation

private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    return formatter
}()

extension Int {
    var withComma: String {
        return formatter.string(from: NSNumber(integerLiteral: self)) ?? "\(self)"
    }
}
