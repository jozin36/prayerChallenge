//
//  CalendarViewModel.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//
import UIKit
import CoreData

class CalendarViewModel {
    private let challenge: Challenge?
    private let context: NSManagedObjectContext
    public var onRequestDecorationRefresh: (() -> Void)?

    init(challenge: Challenge?, context: NSManagedObjectContext) {
        self.challenge = challenge
        self.context = context
    }

    func calendarView(decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        var count = 0
        guard let date = Calendar.current.date(from: dateComponents) else {return nil}
        
        if let ch = challenge {
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
                check.tintColor = .systemGreen
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
}
