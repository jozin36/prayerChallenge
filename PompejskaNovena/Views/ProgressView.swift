//
//  ChallengeProgressView.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 26/08/2025.
//


import UIKit

class ProgressView: UIView {
    
    private let containerView = UIView()
    private let progressBar = UIView()
    private let percentageLabel = UILabel()
    private let daysLabel = UILabel()
    private let completedLabel = UILabel()
    private let missedLabel = UILabel()
    
    private var progressConstraint: NSLayoutConstraint!
    
    var progress = ChallengeProgress(
        percentage: 0,
        completed: 0,
        totalExpected: 0,
        isComplete: false,
        totalDays: 0,
        passedDays: 0,
        missedExercises: 0
    ) {
        didSet {
            updateProgress()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        containerView.backgroundColor = .systemGray5
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.backgroundColor = .systemGreen
        progressBar.layer.cornerRadius = 10
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        percentageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        percentageLabel.textColor = .secondaryLabel
        percentageLabel.textAlignment = .center
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = .systemFont(ofSize: 18, weight: .medium)
        daysLabel.textAlignment = .center
        daysLabel.textColor = .label
        addSubview(daysLabel)
        
        missedLabel.translatesAutoresizingMaskIntoConstraints = false
        missedLabel.font = .systemFont(ofSize: 16, weight: .medium)
        missedLabel.textAlignment = .center
        missedLabel.textColor = .systemRed
        addSubview(missedLabel)
        
        completedLabel.textColor = .label
        completedLabel.font = UIFont(name: "Arial", size: 16)
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedLabel)
        
        addSubview(containerView)
        containerView.addSubview(progressBar)
        addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 20),
            
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: containerView.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            percentageLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            completedLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            completedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            daysLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -35),
            daysLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            missedLabel.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 10),
            missedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        progressConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressConstraint.isActive = true
    }
    
    private func getLocalizedString(_ number: Int)-> String{
        if (number == 1) {
            return "ruženec"
        }
        if (number > 1 && number < 5) {
            return "ružence"
        }
        if (number >= 5 ) {
            return "ružencov"
        }
        
        return ""
    }

    private func updateProgress() {
        percentageLabel.text = "\(Int(progress.percentage * 100))% hotovo"
        completedLabel.text = "Pomodlené \(progress.completed) \(getLocalizedString(progress.completed))"
        daysLabel.text = "\(Int(progress.passedDays + 1)) deň novény z \(progress.totalDays)"
        
        missedLabel.text = "Meškáš \(progress.missedExercises) "
        missedLabel.text?.append(getLocalizedString(progress.missedExercises))
        
        missedLabel.isHidden = progress.missedExercises <= 0
        
        
        layoutIfNeeded()
        
        let clamped = min(max(progress.percentage, 0), 1)
        
        // Animate bar width
        UIView.animate(withDuration: 0.3) {
            self.progressConstraint.constant = self.containerView.bounds.width * clamped
            self.layoutIfNeeded()
        }
    }
}
