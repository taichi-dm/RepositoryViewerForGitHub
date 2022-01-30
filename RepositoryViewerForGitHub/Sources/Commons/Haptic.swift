//
//  Haptic.swift
//  RepositoryViewerForGitHub
//
//  Created by Taichi Arima on 2022/01/30.
//

import Foundation
import UIKit

public enum Haptic {

    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case selection

    public static func run(_ type: Haptic) {
        let closure: () -> Void
        switch type {
        case .notification(let notificationType):
            closure = {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(notificationType)
            }

        case .impact(let style):
            closure = {
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.prepare()
                generator.impactOccurred()
            }

        case .selection:
            closure = {
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                generator.selectionChanged()
            }
        }

        DispatchQueue.main.async {
            closure()
        }
    }
}
