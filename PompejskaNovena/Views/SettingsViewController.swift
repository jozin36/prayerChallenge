//
//  SettingsViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//

import UIKit
import UserNotifications

private let settingsContentMaxWidth: CGFloat = 420

private final class ReminderSettingCardView: UIView {

    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let timeButton = UIButton(type: .system)
    private let topRow = UIStackView()
    private let stack = UIStackView()

    var onToggleChanged: ((Bool) -> Void)?
    var onTimeTapped: ((UIButton) -> Void)?

    private(set) var isEnabled: Bool = false

    init(title: String, timeText: String, isEnabled: Bool) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, timeText: timeText, isEnabled: isEnabled)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(title: String, timeText: String, isEnabled: Bool) {
        titleLabel.text = title
        timeButton.setTitle(timeText, for: .normal)
        toggleSwitch.isOn = isEnabled
        self.isEnabled = isEnabled
        applyState()
    }

    func updateTime(_ text: String) {
        timeButton.setTitle(text, for: .normal)
    }

    func setEnabled(_ enabled: Bool, sendAction: Bool = false) {
        toggleSwitch.setOn(enabled, animated: false)
        isEnabled = enabled
        applyState()
        if sendAction {
            onToggleChanged?(enabled)
        }
    }

    private func setupUI() {
        backgroundColor = ColorProvider.shared.surfaceColour
        layer.cornerRadius = AppDesign.Radius.medium
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0
        layer.borderWidth = 0
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = AppDesign.Font.headline()
        titleLabel.numberOfLines = 0

        toggleSwitch.onTintColor = ColorProvider.shared.firstHalfProgressBarColor
        toggleSwitch.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)

        timeButton.translatesAutoresizingMaskIntoConstraints = false
        timeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timeButton.layer.cornerRadius = AppDesign.Radius.small
        timeButton.layer.cornerCurve = .continuous
        timeButton.layer.borderWidth = 1
        timeButton.layer.borderColor = ColorProvider.shared.strokeColour.cgColor
        timeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        timeButton.contentHorizontalAlignment = .center
        timeButton.addTarget(self, action: #selector(timeTapped), for: .touchUpInside)

        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.distribution = .fill
        topRow.spacing = 12
        topRow.translatesAutoresizingMaskIntoConstraints = false
        topRow.addArrangedSubview(titleLabel)
        topRow.addArrangedSubview(toggleSwitch)

        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(topRow)
        stack.addArrangedSubview(timeButton)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    private func applyState() {
        backgroundColor = isEnabled ? ColorProvider.shared.primaryContainerColour : ColorProvider.shared.elevatedSurfaceColour
        titleLabel.textColor = isEnabled ? ColorProvider.shared.onPrimaryContainerColour : .label
        timeButton.setTitleColor(isEnabled ? ColorProvider.shared.onPrimaryContainerColour : ColorProvider.shared.mutedTextColour, for: .normal)
        //timeButton.layer.borderColor = (isEnabled ? ColorProvider.shared.onPrimaryContainerColour : ColorProvider.shared.strokeColour).cgColor
        timeButton.backgroundColor = ColorProvider.shared.secondaryButtonColour
        layer.cornerRadius = AppDesign.Radius.medium
    }

    @objc private func toggleChanged() {
        isEnabled = toggleSwitch.isOn
        applyState()
        onToggleChanged?(toggleSwitch.isOn)
    }

    @objc private func timeTapped() {
        onTimeTapped?(timeButton)
    }
}

private final class TimePickerModalViewController: UIViewController {
    private let initialDate: Date
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let picker = UIDatePicker()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let buttonRow = UIStackView()
    private let contentStack = UIStackView()

    var onConfirm: ((Date) -> Void)?

    init(initialDate: Date) {
        self.initialDate = initialDate
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = ColorProvider.shared.elevatedSurfaceColour
        cardView.layer.cornerRadius = AppDesign.Radius.medium
        cardView.layer.cornerCurve = .continuous
        cardView.clipsToBounds = true

        titleLabel.text = "Zvoľte čas"
        titleLabel.font = AppDesign.Font.title()
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.date = initialDate
        picker.locale = Locale(identifier: "sk_SK")

        cancelButton.setTitle("Zrušiť", for: .normal)
        cancelButton.applySecondaryStyle()
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        confirmButton.setTitle("Nastaviť", for: .normal)
        confirmButton.applyPrimaryStyle()
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        buttonRow.axis = .horizontal
        buttonRow.distribution = .fillEqually
        buttonRow.spacing = AppDesign.Spacing.sm
        buttonRow.addArrangedSubview(cancelButton)
        buttonRow.addArrangedSubview(confirmButton)

        contentStack.axis = .vertical
        contentStack.spacing = AppDesign.Spacing.md
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(picker)
        contentStack.addArrangedSubview(buttonRow)

        view.addSubview(cardView)
        cardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: AppDesign.Spacing.lg),
            cardView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -AppDesign.Spacing.lg),
            cardView.widthAnchor.constraint(lessThanOrEqualToConstant: 360),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: AppDesign.Spacing.lg),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: AppDesign.Spacing.lg),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -AppDesign.Spacing.lg),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -AppDesign.Spacing.lg),

            picker.heightAnchor.constraint(equalToConstant: 180),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func confirmTapped() {
        onConfirm?(picker.date)
        dismiss(animated: true)
    }
}

class SettingsViewController: UIViewController {

    private let viewModel: SettingsViewModel
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let screenTitleLabel = UILabel()
    private let sectionTitleLabel = UILabel()
    private let sectionSubtitleLabel = UILabel()
    private let themeSectionTitleLabel = UILabel()
    private let themeSegment: UISegmentedControl = {
        let items = AppTheme.allCases.map { $0.displayName }
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = AppTheme.allCases.firstIndex(of: ThemeManager.shared.currentTheme) ?? 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private let dangerZoneTitleLabel = UILabel()
    private let dangerZoneCard = UIView()
    private let dangerZoneCardTitleLabel = UILabel()
    private let dangerZoneCardBodyLabel = UILabel()
    private let resetButton = UIButton(type: .system)

    private var reminderTimes: [Date] = {
        if let stored = UserDefaults.standard.array(forKey: "reminderTimes") as? [Double] {
            return stored.map { Date(timeIntervalSince1970: $0) }
        }

        let calendar = Calendar.current
        let today = Date()
        let times = [
            DateComponents(hour: 7, minute: 0),
            DateComponents(hour: 15, minute: 0),
            DateComponents(hour: 18, minute: 0)
        ]

        return times.compactMap {
            calendar.date(bySettingHour: $0.hour ?? 0, minute: $0.minute ?? 0, second: 0, of: today)
        }
    }()

    private var reminderEnabledStates: [Bool] = {
        if let stored = UserDefaults.standard.array(forKey: "reminderToggleButtons") as? [Bool], stored.count == 3 {
            return stored
        }
        return [false, false, false]
    }()

    private var reminderCards: [ReminderSettingCardView] = []

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorProvider.shared.backgroundColour
        title = "Nastavenia"

        setupUI()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        screenTitleLabel.text = "Nastavenia"
        screenTitleLabel.font = AppDesign.Font.hero()
        screenTitleLabel.textColor = .label
        screenTitleLabel.numberOfLines = 0

        sectionTitleLabel.text = "Denné upozornenia"
        sectionTitleLabel.font = AppDesign.Font.title()
        sectionTitleLabel.textColor = ColorProvider.shared.primaryColour
        sectionTitleLabel.numberOfLines = 0

        sectionSubtitleLabel.text = "Nastavte si upozornenia za deň na modlitbu ruženca"
        sectionSubtitleLabel.font = AppDesign.Font.body()
        sectionSubtitleLabel.textColor = ColorProvider.shared.mutedTextColour
        sectionSubtitleLabel.numberOfLines = 0

        contentStack.addArrangedSubview(screenTitleLabel)
        contentStack.setCustomSpacing(24, after: screenTitleLabel)
        contentStack.addArrangedSubview(sectionTitleLabel)
        contentStack.addArrangedSubview(sectionSubtitleLabel)
        contentStack.setCustomSpacing(16, after: sectionSubtitleLabel)

        let reminderTitles = [
            "Ranná upomienka",
            "Popoludňajšia upomienka",
            "Večerná upomienka"
        ]

        for index in 0..<3 {
            let card = ReminderSettingCardView(
                title: reminderTitles[index],
                timeText: timeString(for: reminderTimes[index]),
                isEnabled: reminderEnabledStates[index]
            )

            card.onToggleChanged = { [weak self] enabled in
                self?.didToggleReminder(at: index, enabled: enabled)
            }

            card.onTimeTapped = { [weak self] button in
                self?.presentTimePicker(for: index, sourceView: button)
            }

            reminderCards.append(card)
            contentStack.addArrangedSubview(card)
        }

        contentStack.setCustomSpacing(16, after: reminderCards.last ?? sectionSubtitleLabel)

        setupThemeSection()
        contentStack.addArrangedSubview(themeSectionTitleLabel)
        contentStack.addArrangedSubview(themeSegment)
        contentStack.setCustomSpacing(16, after: themeSegment)

        setupDangerZoneSection()
        contentStack.addArrangedSubview(dangerZoneTitleLabel)
        contentStack.addArrangedSubview(dangerZoneCard)

        let contentWidthConstraint = contentStack.widthAnchor.constraint(
            equalTo: scrollView.frameLayoutGuide.widthAnchor,
            constant: -48
        )
        contentWidthConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24),
            contentStack.widthAnchor.constraint(lessThanOrEqualToConstant: settingsContentMaxWidth),
            contentWidthConstraint,
        ])
    }

    private func setupThemeSection() {
        themeSectionTitleLabel.text = "Farebný režim"
        themeSectionTitleLabel.font = AppDesign.Font.title()
        themeSectionTitleLabel.textColor = .label
        themeSectionTitleLabel.numberOfLines = 0

        themeSegment.addTarget(self, action: #selector(themeSegmentChanged(_:)), for: .valueChanged)
    }

    private func setupDangerZoneSection() {
        dangerZoneTitleLabel.text = "Nebezpečná zóna"
        dangerZoneTitleLabel.font = AppDesign.Font.title()
        dangerZoneTitleLabel.textColor = ColorProvider.shared.errorColour
        dangerZoneTitleLabel.numberOfLines = 0

        dangerZoneCard.translatesAutoresizingMaskIntoConstraints = false
        dangerZoneCard.backgroundColor = ColorProvider.shared.errorContainerColour
        dangerZoneCard.layer.cornerRadius = AppDesign.Radius.small
        dangerZoneCard.layer.cornerCurve = .continuous

        dangerZoneCardTitleLabel.text = "Resetovať aplikáciu"
        dangerZoneCardTitleLabel.font = AppDesign.Font.headline()
        dangerZoneCardTitleLabel.textColor = ColorProvider.shared.onErrorContainerColour
        dangerZoneCardTitleLabel.numberOfLines = 0

        dangerZoneCardBodyLabel.text = "Táto akcia resetuje aplikáciu do pôvodného stavu a odstráni všetky užívateľské dáta."
        dangerZoneCardBodyLabel.font = AppDesign.Font.body()
        dangerZoneCardBodyLabel.textColor = ColorProvider.shared.onErrorContainerColour
        dangerZoneCardBodyLabel.numberOfLines = 0

        resetButton.setTitle("Resetovať aplikáciu", for: .normal)
        resetButton.applyPrimaryStyle()
        resetButton.backgroundColor = ColorProvider.shared.errorColour
        resetButton.setTitleColor(ColorProvider.shared.onErrorColour, for: .normal)
        resetButton.setTitleColor(ColorProvider.shared.onErrorColour.withAlphaComponent(0.65), for: .highlighted)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        let cardStack = UIStackView(arrangedSubviews: [
            dangerZoneCardTitleLabel,
            dangerZoneCardBodyLabel,
            resetButton
        ])
        cardStack.axis = .vertical
        cardStack.spacing = 12
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        dangerZoneCard.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: dangerZoneCard.topAnchor, constant: 16),
            cardStack.leadingAnchor.constraint(equalTo: dangerZoneCard.leadingAnchor, constant: 16),
            cardStack.trailingAnchor.constraint(equalTo: dangerZoneCard.trailingAnchor, constant: -16),
            cardStack.bottomAnchor.constraint(equalTo: dangerZoneCard.bottomAnchor, constant: -16),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func didToggleReminder(at index: Int, enabled: Bool) {
        reminderEnabledStates[index] = enabled
        saveReminderSettings()

        if enabled {
            viewModel.requestNotificationPermissionIfNeeded()
        }

        scheduleNotifications()
    }

    private func presentTimePicker(for index: Int, sourceView: UIView) {
        let pickerModal = TimePickerModalViewController(initialDate: reminderTimes[index])
        pickerModal.onConfirm = { [weak self] date in
            guard let self else { return }
            self.reminderTimes[index] = date
            self.reminderCards[index].updateTime(self.timeString(for: date))
            self.saveReminderSettings()
            self.scheduleNotifications()
        }

        present(pickerModal, animated: true)
    }

    private func saveReminderSettings() {
        let timeStamps = reminderTimes.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timeStamps, forKey: "reminderTimes")
        UserDefaults.standard.set(reminderEnabledStates, forKey: "reminderToggleButtons")
    }

    @objc private func themeSegmentChanged(_ sender: UISegmentedControl) {
        let selectedTheme = AppTheme.allCases[sender.selectedSegmentIndex]
        ThemeManager.shared.currentTheme = selectedTheme
    }

    @objc private func resetButtonTapped() {
        let alert = UIAlertController(
            title: "Naozaj chcete resetovať aplikáciu",
            message: "Táto akcia resetuje aplikáciu do pôvodného stavu a odstráni všetky užívateľské dáta.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel))
        alert.addAction(UIAlertAction(title: "Resetovať", style: .destructive) { [weak self] _ in
            self?.resetApp()
        })
        present(alert, animated: true)
    }

    private func scheduleNotifications() {
        guard reminderEnabledStates.contains(true) else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            return
        }

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        for (index, date) in reminderTimes.enumerated() where reminderEnabledStates[index] {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)

            let content = UNMutableNotificationContent()
            content.title = "Pompejská novéna"
            content.body = "Nezabudni sa pomodliť ruženec!"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "dailyReminder\(index)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print("❌ Failed to schedule: \(error.localizedDescription)")
                }
            }
        }
    }

    private func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func resetApp() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }

        CoreDataManager.shared.resetCoreData()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: Notification.Name("didResetApp"), object: nil)
        }

        let window = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first

        let context = CoreDataManager.shared.context
        let appCoordinator = AppCoordinator(window: window!, context: context)
        appCoordinator.start()
    }
}
