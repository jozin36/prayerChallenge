//
//  NewChallengeViewModel.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 25/07/2025.
//

import Foundation
import CoreData

final class NewChallengeViewModel {
    var name: String = ""
    var note: String = ""
    var startDate: Date = Date()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveChallenge() -> Challenge? {
        let startDate = Calendar.current.startOfDay(for: startDate)

        let challenge = Challenge(context: context)
        challenge.id = UUID()
        challenge.name = "Pompejská Novéna"
        challenge.note = note
        challenge.startDate = startDate
        challenge.endDate = Calendar.current.date(byAdding: .day, value: 53, to: startDate)! // 54-day challenge

        do {
            try context.save()
            return challenge
        } catch {
            print("❌ Failed to save challenge:", error)
            return nil
        }
    }
    
    func challengeExists()->Bool {
        return CoreDataManager.shared.getCurrentChallenge() != nil
    }
}
