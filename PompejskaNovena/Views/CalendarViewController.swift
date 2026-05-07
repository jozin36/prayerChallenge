//
//  CalendarViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

final class CalendarDayCell: UIView {
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let novenaDayLabel = UILabel()
    private let checkStack = UIStackView()

    private var date: Date?
    private var onTap: ((Date) -> Void)?
    private var defaultTransform = CGAffineTransform.identity

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(with day: CalendarDayInfo, onTap: @escaping (Date) -> Void) {
        self.date = day.date
        self.onTap = onTap

        let isToday = Calendar.current.isDateInToday(day.date)
        let textColor: UIColor

        if isToday {
            backgroundColor = ColorProvider.shared.primaryColour
            textColor = ColorProvider.shared.primaryTextColour
            layer.borderWidth = 2
        } else if day.isCompleted {
            backgroundColor = ColorProvider.shared.primaryContainerColour
            textColor = ColorProvider.shared.onPrimaryContainerColour
            layer.borderWidth = 1
        } else {
            backgroundColor = ColorProvider.shared.surfaceColour
            textColor = .label
            layer.borderWidth = 1
        }

        monthLabel.text = monthString(for: day.date)
        monthLabel.textColor = textColor.withAlphaComponent(0.72)
        dayLabel.text = "\(Calendar.current.component(.day, from: day.date))"
        dayLabel.textColor = textColor
        novenaDayLabel.text = "\(day.dayNumber). deň"
        novenaDayLabel.textColor = textColor.withAlphaComponent(0.72)

        checkStack.arrangedSubviews.forEach { subview in
            checkStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        if day.completedCount > 0 {
            for _ in 0..<day.completedCount {
                let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
                imageView.tintColor = ColorProvider.shared.firstHalfProgressBarColor
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: 14),
                    imageView.heightAnchor.constraint(equalToConstant: 14)
                ])
                checkStack.addArrangedSubview(imageView)
            }
        }
    }

    private func setupUI() {
        layer.cornerRadius = AppDesign.Radius.small
        layer.cornerCurve = .continuous
        layer.borderColor = ColorProvider.shared.strokeColour.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = true

        monthLabel.font = .systemFont(ofSize: 11, weight: .medium)
        monthLabel.textAlignment = .center
        monthLabel.isUserInteractionEnabled = false

        dayLabel.font = .systemFont(ofSize: 20, weight: .bold)
        dayLabel.textAlignment = .center
        dayLabel.isUserInteractionEnabled = false

        novenaDayLabel.font = .systemFont(ofSize: 11, weight: .medium)
        novenaDayLabel.textAlignment = .center
        novenaDayLabel.isUserInteractionEnabled = false

        let textStack = UIStackView(arrangedSubviews: [monthLabel, dayLabel, novenaDayLabel])
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.spacing = 0
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.isUserInteractionEnabled = false

        checkStack.axis = .horizontal
        checkStack.alignment = .center
        checkStack.distribution = .equalCentering
        checkStack.spacing = 1
        checkStack.translatesAutoresizingMaskIntoConstraints = false
        checkStack.isUserInteractionEnabled = false

        addSubview(textStack)
        addSubview(checkStack)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),

            textStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            textStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -4),
            textStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4),

            checkStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePressed(true)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePressed(false)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePressed(false)
    }

    private func monthString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sk_SK")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date)
    }

    @objc private func didTap() {
        guard let date else { return }
        onTap?(date)
    }

    private func animatePressed(_ isPressed: Bool) {
        UIView.animate(withDuration: 0.12) {
            self.transform = isPressed ? self.defaultTransform.scaledBy(x: 0.97, y: 0.97) : self.defaultTransform
            self.alpha = isPressed ? 0.82 : 1
        }
    }
}

final class CalendarViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let periodCard = UIView()
    private let periodTitleLabel = UILabel()
    private let periodDateLabel = UILabel()
    private let legendRow = UIStackView()
    private let emptyCard = UIView()
    private let emptyLabel = UILabel()

    let calendarViewModel: CalendarViewModel
    let progressViewModel: ChallengeProgressViewModel
    var onDateSelected: ((Date) -> Void)?
    var onModalDismiss: (() -> Void)?

    init(calendarViewModel: CalendarViewModel, progressViewModel: ChallengeProgressViewModel) {
        self.calendarViewModel = calendarViewModel
        self.progressViewModel = progressViewModel
        super.init(nibName: nil, bundle: nil)

        calendarViewModel.onRequestDecorationRefresh = { [weak self] in
            self?.reloadCalendar()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadCalendar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCalendar()
    }

    private func setupUI() {
        view.backgroundColor = ColorProvider.shared.backgroundColour

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = AppDesign.Spacing.md
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        titleLabel.text = "Kalendár"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        configurePeriodCard()
        configureLegend()
        configureEmptyCard()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: AppDesign.Spacing.md),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: AppDesign.Spacing.md),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -AppDesign.Spacing.md),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.lg)
        ])
    }

    private func configurePeriodCard() {
        periodCard.translatesAutoresizingMaskIntoConstraints = false
        periodCard.backgroundColor = ColorProvider.shared.secondaryContainerColour
        periodCard.layer.cornerRadius = AppDesign.Radius.small
        periodCard.layer.cornerCurve = .continuous

        periodTitleLabel.text = "Obdobie novény"
        periodTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        periodTitleLabel.textColor = .label
        periodTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        periodDateLabel.font = .systemFont(ofSize: 15)
        periodDateLabel.textColor = .label
        periodDateLabel.numberOfLines = 0
        periodDateLabel.translatesAutoresizingMaskIntoConstraints = false

        periodCard.addSubview(periodTitleLabel)
        periodCard.addSubview(periodDateLabel)

        NSLayoutConstraint.activate([
            periodTitleLabel.topAnchor.constraint(equalTo: periodCard.topAnchor, constant: AppDesign.Spacing.md),
            periodTitleLabel.leadingAnchor.constraint(equalTo: periodCard.leadingAnchor, constant: AppDesign.Spacing.md),
            periodTitleLabel.trailingAnchor.constraint(equalTo: periodCard.trailingAnchor, constant: -AppDesign.Spacing.md),

            periodDateLabel.topAnchor.constraint(equalTo: periodTitleLabel.bottomAnchor, constant: 4),
            periodDateLabel.leadingAnchor.constraint(equalTo: periodCard.leadingAnchor, constant: AppDesign.Spacing.md),
            periodDateLabel.trailingAnchor.constraint(equalTo: periodCard.trailingAnchor, constant: -AppDesign.Spacing.md),
            periodDateLabel.bottomAnchor.constraint(equalTo: periodCard.bottomAnchor, constant: -AppDesign.Spacing.md)
        ])
    }

    private func configureLegend() {
        legendRow.axis = .horizontal
        legendRow.alignment = .center
        legendRow.distribution = .fill
        legendRow.spacing = AppDesign.Spacing.md
        legendRow.translatesAutoresizingMaskIntoConstraints = false

        let leadingSpacer = UIView()
        let trailingSpacer = UIView()
        legendRow.addArrangedSubview(makeLegendItem(color: ColorProvider.shared.primaryContainerColour, text: "Dokončené"))
        legendRow.addArrangedSubview(makeLegendItem(color: ColorProvider.shared.primaryColour, text: "Dnes"))
        legendRow.insertArrangedSubview(leadingSpacer, at: 0)
        legendRow.addArrangedSubview(trailingSpacer)

        leadingSpacer.widthAnchor.constraint(equalTo: trailingSpacer.widthAnchor).isActive = true
    }

    private func configureEmptyCard() {
        emptyCard.translatesAutoresizingMaskIntoConstraints = false
        emptyCard.applyCardStyle()

        emptyLabel.text = "Zatiaľ nie je spustená žiadna novéna."
        emptyLabel.font = AppDesign.Font.body()
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyCard.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: emptyCard.topAnchor, constant: AppDesign.Spacing.lg),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyCard.leadingAnchor, constant: AppDesign.Spacing.lg),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyCard.trailingAnchor, constant: -AppDesign.Spacing.lg),
            emptyLabel.bottomAnchor.constraint(equalTo: emptyCard.bottomAnchor, constant: -AppDesign.Spacing.lg)
        ])
    }

    private func reloadCalendar() {
        contentStack.arrangedSubviews.forEach { subview in
            contentStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        contentStack.addArrangedSubview(titleLabel)
        contentStack.setCustomSpacing(AppDesign.Spacing.lg, after: titleLabel)

        guard let challenge = calendarViewModel.getChallenge() else {
            contentStack.addArrangedSubview(emptyCard)
            return
        }

        periodDateLabel.text = "\(formatDate(challenge.startDate)) - \(formatDate(challenge.endDate))"

        let days = calendarViewModel.days()
        contentStack.addArrangedSubview(periodCard)

        contentStack.addArrangedSubview(legendRow)
        contentStack.setCustomSpacing(AppDesign.Spacing.lg, after: legendRow)

        addPhaseSection(
            title: "Prosebná časť",
            days: days.filter { $0.phase == .petition }
        )

        addPhaseSection(
            title: "Ďakovná časť",
            days: days.filter { $0.phase == .thanksgiving }
        )
    }

    private func addPhaseSection(title: String, days: [CalendarDayInfo]) {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 12
        sectionStack.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label

        let grid = makeGrid(days: days)
        sectionStack.addArrangedSubview(label)
        sectionStack.addArrangedSubview(grid)

        contentStack.addArrangedSubview(sectionStack)
        contentStack.setCustomSpacing(AppDesign.Spacing.lg, after: sectionStack)
    }

    private func makeGrid(days: [CalendarDayInfo]) -> UIStackView {
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 8
        gridStack.translatesAutoresizingMaskIntoConstraints = false

        for chunkStart in stride(from: 0, to: days.count, by: 4) {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 8
            row.distribution = .fillEqually

            let rowDays = Array(days[chunkStart..<min(chunkStart + 4, days.count)])
            rowDays.forEach { day in
                let cell = CalendarDayCell()
                cell.configure(with: day) { [weak self] date in
                    self?.onDateSelected?(date)
                }
                row.addArrangedSubview(cell)
            }

            if rowDays.count < 4 {
                for _ in rowDays.count..<4 {
                    let spacer = UIView()
                    row.addArrangedSubview(spacer)
                }
            }

            gridStack.addArrangedSubview(row)
        }

        return gridStack
    }

    private func makeLegendItem(color: UIColor, text: String) -> UIView {
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 8
        dot.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label

        let stack = UIStackView(arrangedSubviews: [dot, label])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4

        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 16),
            dot.heightAnchor.constraint(equalToConstant: 16)
        ])

        return stack
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sk_SK")
        formatter.dateFormat = "dd. MMMM yyyy"
        return formatter.string(from: date)
    }

    func clearCalendarSelection() {
        // The custom grid does not keep a native selection state.
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onModalDismiss?()
    }

    public func updateProgress() {
        reloadCalendar()
    }
}
