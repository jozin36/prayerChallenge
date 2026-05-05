//
//  AppDesign.swift
//  PompejskaNovena
//
//  Shared visual tokens for the app.
//

import UIKit

enum AppDesign {
    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 14
        static let large: CGFloat = 22
    }

    enum Font {
        static func hero() -> UIFont {
            .systemFont(ofSize: 30, weight: .bold)
        }

        static func title() -> UIFont {
            .systemFont(ofSize: 22, weight: .semibold)
        }

        static func headline() -> UIFont {
            .systemFont(ofSize: 17, weight: .semibold)
        }

        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }

        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .medium)
        }
    }
}

extension UIView {
    func applyCardStyle() {
        backgroundColor = ColorProvider.shared.surfaceColour
        layer.cornerRadius = AppDesign.Radius.small
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = ColorProvider.shared.strokeColour.cgColor
        layer.shadowOpacity = 0
    }
}

extension UIButton {
    func applyPrimaryStyle() {
        backgroundColor = ColorProvider.shared.primaryColour
        layer.cornerRadius = AppDesign.Radius.small
        layer.cornerCurve = .continuous
        titleLabel?.font = AppDesign.Font.headline()
        setTitleColor(ColorProvider.shared.primaryTextColour, for: .normal)
        setTitleColor(ColorProvider.shared.primaryTextColour.withAlphaComponent(0.55), for: .highlighted)
        contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
    }

    func applySecondaryStyle() {
        backgroundColor = ColorProvider.shared.secondaryButtonColour
        layer.cornerRadius = AppDesign.Radius.small
        layer.cornerCurve = .continuous
        titleLabel?.font = AppDesign.Font.headline()
        setTitleColor(ColorProvider.shared.primaryColour, for: .normal)
        setTitleColor(ColorProvider.shared.primaryColour.withAlphaComponent(0.55), for: .highlighted)
        contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
    }
}
