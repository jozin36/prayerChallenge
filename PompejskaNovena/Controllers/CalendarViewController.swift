//
//  CalendarViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemPurple
        
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 15
        calendarView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        
        calendarView.availableDateRange = DateInterval(start: Date(), end: Calendar.current.date(byAdding: .year, value: 1, to: Date())!)
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 450),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
}
