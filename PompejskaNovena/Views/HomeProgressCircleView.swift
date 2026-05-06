//
//  HomeProgressCircleView.swift
//  PompejskaNovena
//

import UIKit

final class HomeProgressCircleView: UIView {
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let labelStack = UIStackView()
    private let topLabel = UILabel()
    private let dayLabel = UILabel()
    private let bottomLabel = UILabel()

    var progress: Double = 0 {
        didSet {
            updateProgress(animated: true)
        }
    }

    var currentDayOffset: Int = 0 {
        didSet {
            updateLabels()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCirclePath()
        updateProgress(animated: false)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == true else { return }
        updateColors()
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 12
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 12
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        topLabel.text = "Deň"
        topLabel.font = .systemFont(ofSize: 14)
        topLabel.textColor = ColorProvider.shared.mutedTextColour
        topLabel.textAlignment = .center

        dayLabel.font = .systemFont(ofSize: 56, weight: .bold)
        dayLabel.textColor = .label
        dayLabel.textAlignment = .center

        bottomLabel.text = "z 54"
        bottomLabel.font = .systemFont(ofSize: 14)
        bottomLabel.textColor = ColorProvider.shared.mutedTextColour
        bottomLabel.textAlignment = .center

        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.spacing = 2
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.addArrangedSubview(topLabel)
        labelStack.addArrangedSubview(dayLabel)
        labelStack.addArrangedSubview(bottomLabel)

        addSubview(labelStack)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalTo: widthAnchor),
            labelStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        updateLabels()
        updateColors()
    }

    private func updateColors() {
        trackLayer.strokeColor = ColorProvider.shared.primaryContainerColour
            .resolvedColor(with: traitCollection)
            .cgColor
        progressLayer.strokeColor = ColorProvider.shared.firstHalfProgressBarColor
            .resolvedColor(with: traitCollection)
            .cgColor
        topLabel.textColor = ColorProvider.shared.mutedTextColour
        dayLabel.textColor = .label
        bottomLabel.textColor = ColorProvider.shared.mutedTextColour
    }

    private func updateLabels() {
        if currentDayOffset >= 0 {
            topLabel.text = "Deň"
            dayLabel.text = "\(min(currentDayOffset + 1, 54))"
            bottomLabel.text = "z 54"
        } else {
            let daysUntilStart = abs(currentDayOffset)
            topLabel.text = "Začíname o"
            dayLabel.text = "\(daysUntilStart)"
            bottomLabel.text = daysString(daysUntilStart)
        }
    }

    private func daysString(_ days: Int) -> String {
        if days == 1 {
            return "deň"
        }

        if days > 1 && days < 5 {
            return "dni"
        }

        return "dní"
    }

    private func updateCirclePath() {
        let inset = progressLayer.lineWidth / 2
        let rect = bounds.insetBy(dx: inset, dy: inset)
        let path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: min(rect.width, rect.height) / 2,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    private func updateProgress(animated: Bool) {
        let clampedProgress = min(max(progress, 0), 1)

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.presentation()?.strokeEnd ?? progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.duration = 0.3
            progressLayer.add(animation, forKey: "strokeEnd")
        }

        progressLayer.strokeEnd = clampedProgress
    }
}
