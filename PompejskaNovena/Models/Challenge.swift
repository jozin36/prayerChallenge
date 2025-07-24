//
//  Challenge.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//


import Foundation
import CoreData

@objc(Challenge)
public class Challenge: NSManagedObject {}

extension Challenge {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var id: UUID
    @NSManaged public var startDate: Date
    @NSManaged public var name: String
    @NSManaged public var note: String?
    @NSManaged public var endDate: Date
    @NSManaged public var exercises: Set<ExerciseEntry>
}

// MARK: - Convenience
extension Challenge {
    var sortedExerciseEntriesByDate: [ExerciseEntry] {
        return exercises.sorted { $0.date < $1.date }
    }
}
