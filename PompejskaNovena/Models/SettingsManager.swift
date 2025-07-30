//
//  SettingsManager.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UIKit

final class SettingsManager {
    static let shared = SettingsManager()

    private let defaults = UserDefaults.standard
    private let remindKey = "dailyReminderEnabled"
    private let remindHourKey = "dailyReminderHour"

    var isReminderEnabled: Bool {
        get { defaults.bool(forKey: remindKey) }
        set { defaults.set(newValue, forKey: remindKey) }
    }

    var reminderHour: Int {
        get { defaults.integer(forKey: remindHourKey) == 0 ? 20 : defaults.integer(forKey: remindHourKey) }
        set { defaults.set(newValue, forKey: remindHourKey) }
    }
}
