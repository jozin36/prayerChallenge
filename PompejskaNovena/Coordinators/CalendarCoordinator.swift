//
//  CalendarCoordinator.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//


import UIKit
import CoreData

final class CalendarCoordinator {
    // MARK: - Properties
    let navigationController: UINavigationController
    private let context: NSManagedObjectContext

    // Keep reference to modal coordinator or view controller if needed
    private var calendarViewModel: CalendarViewModel?

    // MARK: - Init
    init(navigationController: UINavigationController, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.navigationController = navigationController
        self.context = context
    }

    // MARK: - Start
    func start() {
        let viewModel = CalendarViewModel(context: context)
        self.calendarViewModel = viewModel

        let calendarVC = CalendarViewController(viewModel: viewModel)
        calendarVC.onDateSelected = { date in
            self.presentExerciseModal(for: date)
        }

        navigationController.pushViewController(calendarVC, animated: true)
    }

    // MARK: - Present Modal
    private func presentExerciseModal(for date: Date) {
        let modalViewModel = ExerciseModalViewModel(date: date, context: context)

        let modalVC = ExerciseModalViewController(viewModel: modalViewModel)
        modalVC.onSave = { [weak self] in
            self?.calendarViewModel?.refreshDecorations()
        }

        let nav = UINavigationController(rootViewController: modalVC)
        navigationController.present(nav, animated: true)
    }
}
