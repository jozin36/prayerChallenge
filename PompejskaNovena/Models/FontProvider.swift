//
//  FontProvider.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 11/09/2025.
//
import UIKit

enum TextSize: String, CaseIterable {
    case small
    case medium
    case large
    case extraLarge

    var displayName: String {
        switch self {
        case .small: return "Malá"
        case .medium: return "Stredná"
        case .large: return "Veľká"
        case .extraLarge: return "Veľmi veľká"
        }
    }

    var textSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 16
        case .large: return 20
        case .extraLarge: return 24
        }
    }
}


class FontProvider {
    static let shared = FontProvider()

    private let key = "PreferredTextSize"

    var currentSize: TextSize {
        get {
            let raw = UserDefaults.standard.string(forKey: key) ?? TextSize.medium.rawValue
            return TextSize(rawValue: raw) ?? .medium
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }

    func font(for style: UIFont.TextStyle = .body, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: currentSize.textSize, weight: weight)
    }
    
    func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: currentSize.textSize + 4, weight: .bold)
    }
    
    func title2Font() -> UIFont {
        return UIFont.systemFont(ofSize: currentSize.textSize + 2, weight: .bold)
    }
}
