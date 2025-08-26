//
//  CalendarViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate, UIAdaptivePresentationControllerDelegate {

    var completedExercises: [DateComponents: [Bool]] = [:]
    let calendarView = UICalendarView()
    private let progressView: ProgressView = ProgressView()
    let calendarViewModel: CalendarViewModel
    let progressViewModel: ChallengeProgressViewModel
    var onDateSelected: ((Date) -> Void)?
    var onModalDismiss: (() -> Void)?
    private var singleDateSelection: UICalendarSelectionSingleDate?
    
    init(calendarViewModel: CalendarViewModel, progressViewModel: ChallengeProgressViewModel) {
        self.calendarViewModel = calendarViewModel
        self.progressViewModel = progressViewModel
        super.init(nibName: nil, bundle: nil)
        
        calendarViewModel.onRequestDecorationRefresh = { [weak self] in
            guard let self = self else { return }
            self.forceCalendarRedraw()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.layer.cornerRadius = 15
        calendarView.delegate = self
        calendarView.wantsDateDecorations = true
        calendarView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = singleDateSelection
        calendarView.locale = Locale(identifier: "sk_SK")
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 450),
            calendarView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 90),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let challenge = CoreDataManager.shared.getCurrentChallenge() {
            calendarView.availableDateRange = DateInterval(start: challenge.startDate, end: challenge.endDate)
        }
        
        updateProgress()
    }
    
    func calendarView(_ calendarView: UICalendarView, didSelectDate dateComponents: DateComponents?) {

    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return calendarViewModel.calendarView(decorationFor: dateComponents)
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
    
    func clearCalendarSelection() {
        if let selection = singleDateSelection {
            print("Clearing selection")
            selection.selectedDate = nil
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Modal was dismissed by swipe down or programmatically
        print("test")
        self.onModalDismiss?()
    }
    
    public func updateProgress() {
        progressView.progress = progressViewModel.currentProgress()
    }
}
