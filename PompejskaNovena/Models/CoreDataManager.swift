//
//  CoreDataManager.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    private var challenge: Challenge? = nil
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    public func resetCoreData() {
        self.deleteAllChallenges(context: self.context)
        self.challenge = nil
        saveContext()
    }
    
    public func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save context:", error)
        }

    }
    
    private init() {
        container = NSPersistentContainer(name: "PompejskaNovena")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load failed: \(error)")
            }
        }
    }
    
    func setCurrentChallenge(challenge: Challenge)-> Void {
        self.challenge = challenge
    }
    
    func getCurrentChallenge()-> Challenge? {
        return self.challenge
    }
    
    func findActiveChallenge()-> Challenge? {
        return self.getChallenge(named: "Pompejská Novéna")
    }
    
    func getChallenge(named name: String) -> Challenge? {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Failed to fetch challenge named '\(name)':", error)
            return nil
        }
    }
    
    func getOrCreateChallenge(named name: String, startDate: Date) -> Challenge {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        do {
            if let existing = try context.fetch(request).first {
                return existing
            }
        } catch {
            print("❌ Failed to fetch challenge named '\(name)':", error)
        }
        
        let startDate = Calendar.current.startOfDay(for: startDate)

        // Create new Challenge
        let newChallenge = Challenge(context: context)
        newChallenge.id = UUID()
        newChallenge.name = name
        newChallenge.startDate = startDate
        newChallenge.endDate = Calendar.current.date(byAdding: .day, value: 53, to: startDate)!

        do {
            try context.save()
            print("✅ Created new challenge: \(name)")
        } catch {
            print("❌ Failed to save new challenge:", error)
        }

        return newChallenge
    }
    
    func createChallenge(named name: String, note: String?, startDate: Date, endDate: Date) -> Challenge {
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        do {
            if let existing = try context.fetch(request).first {
                return existing
            }
        } catch {
            print("❌ Failed to fetch challenge named '\(name)':", error)
        }

        // Create new Challenge
        let newChallenge = Challenge(context: context)
        newChallenge.id = UUID()
        newChallenge.name = name
        newChallenge.startDate = startDate
        newChallenge.endDate = endDate

        do {
            try context.save()
            print("✅ Created new challenge: \(name)")
        } catch {
            print("❌ Failed to save new challenge:", error)
        }

        return newChallenge
    }
    
    func getCompletedExerciseCount(for date: Date, challenge: Challenge) -> Int {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        let request: NSFetchRequest<ExerciseEntry> = ExerciseEntry.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date == %@", normalizedDate as NSDate),
            NSPredicate(format: "isCompleted == true"),
            NSPredicate(format: "challenge == %@", challenge)
        ])
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Error fetching completed exercise count:", error)
            return 0
        }
    }
    
    func getCompletedExercises(for date: Date, challenge: Challenge) -> [ExerciseEntry] {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        let request: NSFetchRequest<ExerciseEntry> = ExerciseEntry.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date == %@", normalizedDate as NSDate),
            NSPredicate(format: "challenge == %@", challenge),
            NSPredicate(format: "isCompleted == true")
        ])
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("Error fetching completed exercises:", error)
            return []
        }
    }
    
    func getAllExercises(for date: Date, challenge: Challenge) -> [ExerciseEntry] {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        let request: NSFetchRequest<ExerciseEntry> = ExerciseEntry.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date == %@", normalizedDate as NSDate),
            NSPredicate(format: "challenge == %@", challenge)
        ])
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching exercises for date:", error)
            return []
        }
    }
    
    func deleteAllChallenges(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Challenge.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            
            self.challenge = nil
            print("✅ All challenges deleted successfully.")
        } catch {
            print("❌ Failed to delete challenges: \(error)")
        }
    }
    
    func areAllExercisesCompleted(for date: Date, challenge: Challenge) -> Bool {
        let context = self.context
        
        let fetchRequest: NSFetchRequest<ExerciseEntry> = ExerciseEntry.fetchRequest()
        
        // Create date range (start of day to end of day)
        let calendar = Calendar.current
        guard let startOfDay = calendar.startOfDay(for: date) as NSDate?,
              let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay as Date)?.addingTimeInterval(-1) as NSDate? else {
            return false
        }

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "date >= %@ AND date <= %@", startOfDay, endOfDay),
            NSPredicate(format: "challenge == %@", challenge)
        ])

        do {
            let entries = try context.fetch(fetchRequest)
            let completedCount = entries.filter { $0.isCompleted }.count
            return completedCount == 3
        } catch {
            print("❌ Failed to fetch exercise entries: \(error)")
            return false
        }
    }
}
