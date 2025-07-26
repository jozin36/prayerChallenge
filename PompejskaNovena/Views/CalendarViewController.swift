//
//  CalendarViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

    var completedExercises: [DateComponents: [Bool]] = [:]
    let calendarView = UICalendarView()
    let viewModel: CalendarViewModel
    var onDateSelected: ((Date) -> Void)?
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.onRequestDecorationRefresh = { [weak self] in
            guard let self = self else { return }
            self.forceCalendarRedraw()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemPurple
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.layer.cornerRadius = 15
        calendarView.delegate = self
        calendarView.wantsDateDecorations = true
        calendarView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 450),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let challenge = viewModel.getChallenge() {
            calendarView.availableDateRange = DateInterval(start: challenge.startDate, end: challenge.endDate)
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, didSelectDate dateComponents: DateComponents?) {

    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return viewModel.calendarView(decorationFor: dateComponents)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let components = dateComponents else { return }
        if let date = Calendar.current.date(from: components)
        {
            self.onDateSelected?(date)
        }
    }
    
    func forceCalendarRedraw() {
        guard let scrollView = findScrollView(in: self.view) else { return }

        let originalOffset = scrollView.contentOffset
        let nudgedOffset = CGPoint(x: originalOffset.x + 1, y: originalOffset.y)

        scrollView.setContentOffset(nudgedOffset, animated: true)
        scrollView.setContentOffset(originalOffset, animated: true)
    }
    
    private func findScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for subview in view.subviews {
            if let found = findScrollView(in: subview) {
                return found
            }
        }
        return nil
    }
}
