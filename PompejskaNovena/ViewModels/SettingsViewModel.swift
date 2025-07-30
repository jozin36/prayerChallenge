//
//  SettingsViewModel.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UIKit

final class SettingsViewModel {
    var isReminderEnabled: Bool {
        get { SettingsManager.shared.isReminderEnabled }
        set { SettingsManager.shared.isReminderEnabled = newValue }
    }

    var reminderHour: Int {
        get { SettingsManager.shared.reminderHour }
        set { SettingsManager.shared.reminderHour = newValue }
    }

    func requestNotificationPermissionIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print(granted ? "✅ Permission granted" : "❌ Permission denied")
        }
    }
}
