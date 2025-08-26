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
    private var viewController: CalendarViewController?

    // Keep reference to modal coordinator or view controller if needed
    private var calendarViewModel: CalendarViewModel?

    // MARK: - Init
    init(navigationController: UINavigationController, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.navigationController = navigationController
        self.context = context
    }

    // MARK: - Start
    func start() {
        let calendarViewModel = CalendarViewModel(context: context)
        let challengeViewModel = ChallengeProgressViewModel(context: self.context)
        self.calendarViewModel = calendarViewModel

        let calendarVC = CalendarViewController(calendarViewModel: calendarViewModel, progressViewModel: challengeViewModel)
        calendarVC.onDateSelected = { date in
            self.presentExerciseModal(for: date)
        }
        
        calendarVC.onModalDismiss = {
            self.calendarViewModel?.refreshDecorations()
            calendarVC.updateProgress()
        }

        self.viewController = calendarVC
        navigationController.pushViewController(calendarVC, animated: true)
    }

    // MARK: - Present Modal
    private func presentExerciseModal(for date: Date) {
        let modalViewModel = ExerciseModalViewModel(date: date, context: context)
        let modalVC = ExerciseModalViewController(viewModel: modalViewModel)
        //modalVC.presentationController?.delegate = self.viewController
        
        modalVC.onSave = { [weak self] in
            self?.calendarViewModel?.refreshDecorations()
            self?.viewController?.updateProgress()
        }
        viewController?.clearCalendarSelection()

        let nav = UINavigationController(rootViewController: modalVC)
        navigationController.present(nav, animated: true)
    }
}
