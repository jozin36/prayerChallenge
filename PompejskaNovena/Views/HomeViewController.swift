//
//  HomeViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class HomeViewController: UIViewController {
    public var buttonClickedCallback: (()-> Void)?
    
    private let progressCircleView = HomeProgressCircleView()
    private let viewModel: ChallengeProgressViewModel
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let infoLabel = UILabel()
    private let noteLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let phaseCard = UIView()
    private let phaseLabel = UILabel()
    private let startDateLabel = UILabel()
    private let intentionCard = UIView()
    private let intentionTitleLabel = UILabel()
    private let completionCard = UIView()
    private let completionLabel = UILabel()
    private let startButton = UIButton()
    private let restartButton = UIButton()
    private let emptyStateTopSpacer = UIView()
    private let emptyStateBottomSpacer = UIView()
    private var emptyStateConstraints: [NSLayoutConstraint] = []

    init(viewModel: ChallengeProgressViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public func setupUI()->Void {
        view.backgroundColor = ColorProvider.shared.backgroundColour
        configureBaseViews()

        if let challenge = viewModel.getChallenge() {
            infoLabel.text = "Pompejská novéna"
            startDateLabel.text = "Začatá \(formatDate(challenge.startDate))"
            noteLabel.text = (challenge.note?.isEmpty == false) ? challenge.note : "Bez úmyslu"

            restartButton.setTitle("Začať odznovu", for: .normal)

            contentStack.addArrangedSubview(infoLabel)
            contentStack.setCustomSpacing(AppDesign.Spacing.xl, after: infoLabel)
            contentStack.addArrangedSubview(progressCircleView)
            contentStack.addArrangedSubview(phaseCard)
            contentStack.addArrangedSubview(startDateLabel)
            contentStack.addArrangedSubview(intentionCard)
            contentStack.addArrangedSubview(restartButton)
            contentStack.addArrangedSubview(completionCard)

            activateActiveNovenaConstraints()
        } else {
            welcomeLabel.text = "Pompejská Novéna"
            subtitleLabel.text = "Začni novénu a sleduj svoj denný pokrok."

            startButton.setTitle("Začať pompejskú novénu", for: .normal)

            contentStack.addArrangedSubview(emptyStateTopSpacer)
            contentStack.addArrangedSubview(welcomeLabel)
            contentStack.addArrangedSubview(subtitleLabel)
            contentStack.setCustomSpacing(AppDesign.Spacing.xl, after: subtitleLabel)
            contentStack.addArrangedSubview(startButton)
            contentStack.addArrangedSubview(emptyStateBottomSpacer)

            activateEmptyStateConstraints()
        }

        updateProgress()
    }

    private func configureBaseViews() {
        NSLayoutConstraint.deactivate(emptyStateConstraints)
        emptyStateConstraints.removeAll()

        contentStack.arrangedSubviews.forEach { subview in
            contentStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = AppDesign.Spacing.lg
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        infoLabel.textColor = .label
        infoLabel.font = .systemFont(ofSize: 28, weight: .bold)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        welcomeLabel.textColor = .label
        welcomeLabel.font = AppDesign.Font.hero()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.textColor = ColorProvider.shared.mutedTextColour
        subtitleLabel.font = AppDesign.Font.body()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        noteLabel.textColor = ColorProvider.shared.mutedTextColour
        noteLabel.font = AppDesign.Font.body()
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        noteLabel.textAlignment = .left
        noteLabel.translatesAutoresizingMaskIntoConstraints = false

        progressCircleView.translatesAutoresizingMaskIntoConstraints = false

        phaseCard.translatesAutoresizingMaskIntoConstraints = false
        phaseCard.backgroundColor = ColorProvider.shared.primaryContainerColour
        phaseCard.layer.cornerRadius = AppDesign.Radius.small
        phaseCard.layer.cornerCurve = .continuous

        phaseLabel.textColor = ColorProvider.shared.onPrimaryContainerColour
        phaseLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        phaseLabel.textAlignment = .center
        phaseLabel.numberOfLines = 0
        phaseLabel.translatesAutoresizingMaskIntoConstraints = false
        phaseCard.addSubview(phaseLabel)

        startDateLabel.font = .systemFont(ofSize: 15)
        startDateLabel.textColor = ColorProvider.shared.mutedTextColour
        startDateLabel.textAlignment = .center
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false

        intentionCard.translatesAutoresizingMaskIntoConstraints = false
        intentionCard.applyCardStyle()

        intentionTitleLabel.text = "Úmysel modlitby"
        intentionTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        intentionTitleLabel.textColor = .label
        intentionTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        intentionCard.addSubview(intentionTitleLabel)
        intentionCard.addSubview(noteLabel)

        completionCard.translatesAutoresizingMaskIntoConstraints = false
        completionCard.backgroundColor = ColorProvider.shared.primaryContainerColour
        completionCard.layer.cornerRadius = AppDesign.Radius.small
        completionCard.layer.cornerCurve = .continuous

        completionLabel.text = "Gratulujeme, novéna je úspešne dokončená."
        completionLabel.font = AppDesign.Font.body()
        completionLabel.textColor = ColorProvider.shared.onPrimaryContainerColour
        completionLabel.textAlignment = .center
        completionLabel.numberOfLines = 0
        completionLabel.translatesAutoresizingMaskIntoConstraints = false
        completionCard.addSubview(completionLabel)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.applyPrimaryStyle()
        startButton.removeTarget(nil, action: nil, for: .touchUpInside)
        startButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)

        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.applySecondaryStyle()
        restartButton.removeTarget(nil, action: nil, for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)

        emptyStateTopSpacer.translatesAutoresizingMaskIntoConstraints = false
        emptyStateBottomSpacer.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: AppDesign.Spacing.xl),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: AppDesign.Spacing.lg),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -AppDesign.Spacing.lg),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.lg),

            phaseLabel.topAnchor.constraint(equalTo: phaseCard.topAnchor, constant: AppDesign.Spacing.md),
            phaseLabel.leadingAnchor.constraint(equalTo: phaseCard.leadingAnchor, constant: AppDesign.Spacing.md),
            phaseLabel.trailingAnchor.constraint(equalTo: phaseCard.trailingAnchor, constant: -AppDesign.Spacing.md),
            phaseLabel.bottomAnchor.constraint(equalTo: phaseCard.bottomAnchor, constant: -AppDesign.Spacing.md),

            intentionTitleLabel.topAnchor.constraint(equalTo: intentionCard.topAnchor, constant: AppDesign.Spacing.md),
            intentionTitleLabel.leadingAnchor.constraint(equalTo: intentionCard.leadingAnchor, constant: AppDesign.Spacing.md),
            intentionTitleLabel.trailingAnchor.constraint(equalTo: intentionCard.trailingAnchor, constant: -AppDesign.Spacing.md),
            noteLabel.topAnchor.constraint(equalTo: intentionTitleLabel.bottomAnchor, constant: AppDesign.Spacing.sm),
            noteLabel.leadingAnchor.constraint(equalTo: intentionCard.leadingAnchor, constant: AppDesign.Spacing.md),
            noteLabel.trailingAnchor.constraint(equalTo: intentionCard.trailingAnchor, constant: -AppDesign.Spacing.md),
            noteLabel.bottomAnchor.constraint(equalTo: intentionCard.bottomAnchor, constant: -AppDesign.Spacing.md),

            completionLabel.topAnchor.constraint(equalTo: completionCard.topAnchor, constant: AppDesign.Spacing.md),
            completionLabel.leadingAnchor.constraint(equalTo: completionCard.leadingAnchor, constant: AppDesign.Spacing.md),
            completionLabel.trailingAnchor.constraint(equalTo: completionCard.trailingAnchor, constant: -AppDesign.Spacing.md),
            completionLabel.bottomAnchor.constraint(equalTo: completionCard.bottomAnchor, constant: -AppDesign.Spacing.md)
        ])
    }

    private func activateActiveNovenaConstraints() {
        NSLayoutConstraint.activate([
            phaseCard.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            startDateLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            intentionCard.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            restartButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            completionCard.widthAnchor.constraint(equalTo: contentStack.widthAnchor)
        ])
    }

    private func activateEmptyStateConstraints() {
        NSLayoutConstraint.deactivate(emptyStateConstraints)
        emptyStateConstraints = [
            contentStack.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor, constant: -(AppDesign.Spacing.xl + AppDesign.Spacing.lg)),
            emptyStateTopSpacer.heightAnchor.constraint(equalTo: emptyStateBottomSpacer.heightAnchor)
        ]

        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ] + emptyStateConstraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProgress()
    }
    
    private func updateProgress() {
        let progress = viewModel.currentProgress()
        progressCircleView.progress = progress.percentage
        progressCircleView.currentDayOffset = progress.passedDays

        phaseLabel.text = progress.passedDays + 1 <= 27 ? "Prosebná časť" : "Ďakovná časť"
        restartButton.isHidden = viewModel.getChallenge() == nil
        completionCard.isHidden = !progress.isComplete
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sk_SK")
        formatter.dateFormat = "dd. MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @objc private func didPushButton() {
        self.buttonClickedCallback?()
    }
}
