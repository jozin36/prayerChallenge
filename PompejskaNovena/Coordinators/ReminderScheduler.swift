//
//  ReminderScheduler.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UserNotifications
import CoreData

final class ReminderScheduler {
    static let shared = ReminderScheduler()

    func scheduleReminder(for challenge: Challenge, context: NSManagedObjectContext) {
        guard SettingsManager.shared.isReminderEnabled else {
            print("🔕 Reminders disabled in settings")
            return
        }

        let today = Calendar.current.startOfDay(for: Date())
        let isComplete = CoreDataManager.shared.areAllExercisesCompleted(for: today, challenge: challenge)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])

        guard !isComplete else {
            print("✅ All exercises done — no reminder needed")
            return
        }

        var components = DateComponents()
        components.hour = SettingsManager.shared.reminderHour

        let content = UNMutableNotificationContent()
        content.title = "🏁 Don’t forget your challenge"
        content.body = "You have exercises left today. Tap to catch up!"
        content.sound = .default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule:", error)
            } else {
                print("📬 Reminder scheduled for \(components.hour ?? 0):00")
            }
        }
    }

    func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        print("🧹 Reminder canceled")
    }
}
