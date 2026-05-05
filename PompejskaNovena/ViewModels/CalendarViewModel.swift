//
//  CalendarViewModel.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//
import UIKit
import CoreData

enum CalendarNovenaPhase {
    case petition
    case thanksgiving
}

struct CalendarDayInfo {
    let dayNumber: Int
    let date: Date
    let completedCount: Int
    let phase: CalendarNovenaPhase

    var isCompleted: Bool {
        completedCount >= 3
    }
}

class CalendarViewModel {
    private let context: NSManagedObjectContext
    public var onRequestDecorationRefresh: (() -> Void)?

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func calendarView(decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        var count = 0
        guard let date = Calendar.current.date(from: dateComponents) else {return nil}
        
        if let ch = CoreDataManager.shared.getCurrentChallenge() {
            count = CoreDataManager.shared.getCompletedExerciseCount(for: date, challenge: ch)
        }
        guard count > 0 else {
            return nil
        }
        
        return .customView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .equalSpacing
            stack.spacing = 1
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            for _ in 0..<count {
                let check = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
                check.tintColor = ColorProvider.shared.firstHalfProgressBarColor
                check.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    check.widthAnchor.constraint(equalToConstant: 13),
                    check.heightAnchor.constraint(equalToConstant: 13)
                ])
                stack.addArrangedSubview(check)
            }
            
            // Container view to center the stack
            let container = UIView()
            container.addSubview(stack)
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            
            return container
        }
    }

    func refreshDecorations() {
        onRequestDecorationRefresh?()
    }

    func days() -> [CalendarDayInfo] {
        guard let challenge = getChallenge() else { return [] }

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: challenge.startDate)

        return (0..<54).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }

            return CalendarDayInfo(
                dayNumber: offset + 1,
                date: date,
                completedCount: CoreDataManager.shared.getCompletedExerciseCount(for: date, challenge: challenge),
                phase: offset < 27 ? .petition : .thanksgiving
            )
        }
    }
    
    func getChallenge() -> Challenge? {
        return CoreDataManager.shared.getCurrentChallenge()
    }
}
