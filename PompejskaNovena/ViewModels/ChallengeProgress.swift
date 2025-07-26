//
//  ChallengeProgress.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 25/07/2025.
//


import Foundation
import CoreData

struct ChallengeProgress {
    let percentage: Double      // 0.0 to 1.0
    let completed: Int
    let totalExpected: Int
    let isComplete: Bool
    let totalDays: Int
    let passedDays: Int
    let missedExercises: Int
}

final class ChallengeProgressViewModel {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func currentProgress() -> ChallengeProgress {
        guard let challenge = CoreDataManager.shared.getCurrentChallenge() else {
            return ChallengeProgress(percentage: 0.0, completed: 0, totalExpected: 0, isComplete: false, totalDays: 0, passedDays: 0, missedExercises: 0)
        }
        
        let start = challenge.startDate
        let end = challenge.endDate

        // Total expected = (days in range) × 3 exercises per day
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        let totalExpected = (days + 1) * 3

        let request: NSFetchRequest<ExerciseEntry> = ExerciseEntry.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isCompleted == YES"),
            NSPredicate(format: "challenge == %@", challenge)
        ])

        do {
            let calendar = Calendar.current
            let completed = try context.count(for: request)
            let percent = Double(completed) / Double(max(totalExpected, 1))
            
            let today = calendar.startOfDay(for: Date())
            let clampedToday = min(max(today, start), end)
            
            let totalDays = calendar.dateComponents([.day], from: start, to: end).day ?? 1
            let passedDays = calendar.dateComponents([.day], from: start, to: clampedToday).day ?? 0
            
            print("start date: \(challenge.startDate)")
            print("endDate: \(challenge.endDate)")
            print("passedDays: \(passedDays)")
            
            return ChallengeProgress(
                percentage: min(percent, 1.0),
                completed: completed,
                totalExpected: totalExpected,
                isComplete: completed >= totalExpected,
                totalDays: totalDays + 1,
                passedDays: passedDays,
                missedExercises: (passedDays*3) - completed
            )
        } catch {
            print("❌ Failed to count completed exercises:", error)
            return ChallengeProgress(percentage: 0, completed: 0, totalExpected: totalExpected, isComplete: false, totalDays: 0, passedDays: 0, missedExercises: 0)
        }
    }
    
    func getChallenge() -> Challenge? {
        return CoreDataManager.shared.getCurrentChallenge()
    }
}
