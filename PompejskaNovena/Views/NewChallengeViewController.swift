//
//  NewChallengeViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 25/07/2025.
//
import UIKit
import CoreData

final class NewChallengeViewController: UIViewController {
    private let viewModel: NewChallengeViewModel
    var onChallengeCreated: ((Challenge) -> Void)?

    private let titleLabel = UILabel()
    private let intentionPromptLabel = UILabel()
    private let mottoView = UITextView()
    private let placeholderLabel = UILabel()
    private let startDateLabel = UILabel()
    private let dateButton = UIButton(type: .system)
    private let startButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let alertLabel = UILabel()
    private let warningLabel = UILabel()
    private var selectedStartDate = Date()

    init(viewModel: NewChallengeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 360, height: 480)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupUI() {
        self.view.backgroundColor = ColorProvider.shared.backgroundColour

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.challengeExists() ? "Začať novénu odznovu" : "Začať novénu"

        intentionPromptLabel.text = "Zadajte úmysel"
        intentionPromptLabel.font = AppDesign.Font.body()
        intentionPromptLabel.textColor = ColorProvider.shared.mutedTextColour

        mottoView.font = AppDesign.Font.body()
        mottoView.backgroundColor = ColorProvider.shared.surfaceColour
        mottoView.layer.borderWidth = 1
        mottoView.layer.borderColor = ColorProvider.shared.strokeColour.cgColor
        mottoView.layer.cornerRadius = AppDesign.Radius.small
        mottoView.layer.cornerCurve = .continuous
        mottoView.isScrollEnabled = true
        mottoView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        mottoView.translatesAutoresizingMaskIntoConstraints = false
        mottoView.delegate = self
        
        placeholderLabel.text = "Úmysel modlitby"
        placeholderLabel.font = mottoView.font
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        mottoView.addSubview(placeholderLabel)
        addDoneToolbar(to: mottoView)
        
        alertLabel.text = "Ak začnete znovu, všetky uložené dáta a história z predošlej novény sa vymažú!"
        alertLabel.textColor = .systemRed
        alertLabel.font = .systemFont(ofSize: 13)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.numberOfLines = 0
        alertLabel.lineBreakMode = .byWordWrapping
        alertLabel.textAlignment = .left
        
        warningLabel.text = "Upozornenie"
        warningLabel.textColor = .systemRed
        warningLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.numberOfLines = 0
        warningLabel.lineBreakMode = .byWordWrapping
        warningLabel.textAlignment = .left

        startDateLabel.text = "Vyberte počiatočný dátum"
        startDateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        startDateLabel.textColor = .label

        dateButton.setTitle(formatDate(selectedStartDate), for: .normal)
        dateButton.layer.cornerRadius = AppDesign.Radius.small
        dateButton.layer.cornerCurve = .continuous
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = ColorProvider.shared.strokeColour.cgColor
        dateButton.backgroundColor = .clear
        dateButton.setTitleColor(ColorProvider.shared.primaryColour, for: .normal)
        dateButton.titleLabel?.font = AppDesign.Font.body()
        var dateButtonConfiguration = UIButton.Configuration.plain()
        dateButtonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        dateButton.configuration = dateButtonConfiguration
        dateButton.contentHorizontalAlignment = .center
        dateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)

        startButton.applyPrimaryStyle()
        cancelButton.applySecondaryStyle()

        startButton.setTitle("Začať novénu", for: .normal)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        cancelButton.setTitle("Zrušiť", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let buttonRow = UIStackView(arrangedSubviews: [cancelButton, startButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = AppDesign.Spacing.sm
        buttonRow.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            warningLabel,
            alertLabel,
            intentionPromptLabel,
            mottoView,
            startDateLabel,
            dateButton,
            buttonRow
        ])
        stack.axis = .vertical
        stack.spacing = AppDesign.Spacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppDesign.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppDesign.Spacing.lg),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppDesign.Spacing.lg),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.sm),
            mottoView.heightAnchor.constraint(equalToConstant: 96),
            dateButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            startButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            cancelButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            placeholderLabel.topAnchor.constraint(equalTo: mottoView.topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: mottoView.leadingAnchor, constant: 13)
        ])

        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .init("restartCompact")) { _ in 480 }
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = AppDesign.Radius.large
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (viewModel.challengeExists()) {
            alertLabel.isHidden = false
            warningLabel.isHidden = false
        } else {
            alertLabel.isHidden = true
            warningLabel.isHidden = true
        }
    }
    
    func addDoneToolbar(to textView: UITextView) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Hotovo", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flex, done], animated: false)
        textView.inputAccessoryView = toolbar
    }

    @objc private func startTapped() {
        viewModel.name = "Pompejská Novéna"
        viewModel.note = mottoView.text ?? ""
        viewModel.startDate = selectedStartDate

        guard let challenge = viewModel.saveChallenge() else {
            // Alert for empty name
            let alert = UIAlertController(title: "Chýba názov", message: "Prosím vyplň názov novény.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        onChallengeCreated?(challenge)
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func showDatePicker() {
        view.endEditing(true)

        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "sk_SK")
        picker.calendar = Calendar.autoupdatingCurrent
        picker.date = selectedStartDate
        picker.translatesAutoresizingMaskIntoConstraints = false

        let alert = UIAlertController(title: "Vyberte počiatočný dátum", message: nil, preferredStyle: .alert)
        alert.view.addSubview(picker)

        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 52),
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 8),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -8),
            picker.heightAnchor.constraint(equalToConstant: 320)
        ])

        alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self else { return }
            self.selectedStartDate = picker.date
            self.dateButton.setTitle(self.formatDate(picker.date), for: .normal)
        })

        let height = NSLayoutConstraint(
            item: alert.view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 430
        )
        alert.view.addConstraint(height)

        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sk_SK")
        formatter.dateFormat = "dd. MMMM yyyy"
        return formatter.string(from: date)
    }
}

extension NewChallengeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
