//
//  ExerciseModalViewModel.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//


import Foundation
import CoreData

final class ExerciseModalViewModel: ObservableObject {
    // MARK: - Public API
    private let date: Date
    @Published var exerciseStates: [String: Bool] = [:]

    // MARK: - Private
    private let context: NSManagedObjectContext
    private let exerciseTypes = ["Radostný", "Bolestný", "Slávnostný"]
    private var existingEntries: [String: ExerciseEntry] = [:]

    // MARK: - Init
    init(date: Date, context: NSManagedObjectContext) {
        self.date = Calendar.current.startOfDay(for: date)
        self.context = context

        let challenge = CoreDataManager.shared.getCurrentChallenge()
        if ((challenge) != nil) {
            loadOrCreateExerciseEntries()
        }
    }

    // MARK: - Load
    private func loadOrCreateExerciseEntries() {
        guard let challenge = CoreDataManager.shared.getCurrentChallenge() else {return}
        let results = CoreDataManager.shared.getAllExercises(for: date, challenge: challenge)
        
        for entry in results {
            existingEntries[entry.type] = entry
            exerciseStates[entry.type] = entry.isCompleted
        }

        // Create missing entries
        for type in exerciseTypes {
            if existingEntries[type] == nil {
                let entry = ExerciseEntry(context: context)
                entry.date = date
                entry.type = type
                entry.isCompleted = false
                entry.challenge = challenge

                existingEntries[type] = entry
                exerciseStates[type] = false
            }
        }
    }

    // MARK: - Save
    func save() {
        for (type, isCompleted) in exerciseStates {
            existingEntries[type]?.isCompleted = isCompleted
        }

        do {
            try context.save()
            print("✅ Saved exercise states for \(date)")
        } catch {
            print("❌ Failed to save exercise states:", error)
        }
    }

    // MARK: - Helpers
    func toggleState(for type: String) {
        guard exerciseStates[type] != nil else { return }
        exerciseStates[type]!.toggle()
    }

    func state(for type: String) -> Bool {
        return exerciseStates[type] ?? false
    }

    var sortedExerciseTypes: [String] {
        return exerciseTypes
    }
}
