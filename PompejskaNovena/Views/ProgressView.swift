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
    private let midpointMarker = UIView()
    
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
        backgroundColor = .clear

        containerView.backgroundColor = ColorProvider.shared.secondaryButtonColour
        containerView.layer.cornerRadius = AppDesign.Radius.small
        containerView.layer.cornerCurve = .continuous
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.backgroundColor = ColorProvider.shared.firstHalfProgressBarColor
        progressBar.layer.cornerRadius = AppDesign.Radius.small
        progressBar.layer.cornerCurve = .continuous
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        percentageLabel.font = AppDesign.Font.title()
        percentageLabel.textColor = .label
        percentageLabel.textAlignment = .center
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = AppDesign.Font.caption()
        daysLabel.textAlignment = .center
        daysLabel.textColor = ColorProvider.shared.mutedTextColour
        addSubview(daysLabel)
        
        missedLabel.translatesAutoresizingMaskIntoConstraints = false
        missedLabel.font = AppDesign.Font.caption()
        missedLabel.textAlignment = .center
        missedLabel.textColor = .systemRed
        addSubview(missedLabel)
        
        completedLabel.textColor = ColorProvider.shared.mutedTextColour
        completedLabel.font = AppDesign.Font.body()
        completedLabel.textAlignment = .center
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedLabel)
        
        addSubview(containerView)
        containerView.addSubview(progressBar)
        addSubview(percentageLabel)
        
        midpointMarker.translatesAutoresizingMaskIntoConstraints = false
        midpointMarker.backgroundColor = ColorProvider.shared.strokeColour
        containerView.addSubview(midpointMarker)
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: topAnchor),
            daysLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            percentageLabel.topAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: AppDesign.Spacing.xs),
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            containerView.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: AppDesign.Spacing.md),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 18),
            
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: containerView.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            completedLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: AppDesign.Spacing.md),
            completedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            completedLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            completedLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            missedLabel.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: AppDesign.Spacing.xs),
            missedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            missedLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        progressConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Remove any existing constraints on midpointMarker
        midpointMarker.constraints.forEach { midpointMarker.removeConstraint($0) }
        midpointMarker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            midpointMarker.widthAnchor.constraint(equalToConstant: 2),
            midpointMarker.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.2),
            midpointMarker.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            midpointMarker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerView.frame.width * 0.5)
        ])
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
        
        if (progress.percentage <= 0.5) {
            progressBar.backgroundColor = ColorProvider.shared.firstHalfProgressBarColor
            daysLabel.text?.append(" - prosebná časť")
        } else {
            progressBar.backgroundColor = ColorProvider.shared.secondHalfProgressBarColor
            daysLabel.text?.append(" - ďakovná časť")
        }
        
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
