//
//  ExerciseEntry.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//


import Foundation
import CoreData

@objc(ExerciseEntry)
public class ExerciseEntry: NSManagedObject {}

extension ExerciseEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntry> {
        return NSFetchRequest<ExerciseEntry>(entityName: "ExerciseEntry")
    }

    @NSManaged public var date: Date
    @NSManaged public var type: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var challenge: Challenge
}
