//
//  AppTheme.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 11/09/2025.
//


import UIKit

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class ThemeManager {
    static let shared = ThemeManager()

    private let themeKey = "AppTheme"

    var currentTheme: AppTheme {
        get {
            if let stored = UserDefaults.standard.string(forKey: themeKey),
               let theme = AppTheme(rawValue: stored) {
                return theme
            }
            return .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            apply(theme: newValue)
        }
    }

    func apply(theme: AppTheme) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                window.overrideUserInterfaceStyle = theme.interfaceStyle
            }
    }

    func applySavedTheme() {
        apply(theme: currentTheme)
    }
}
