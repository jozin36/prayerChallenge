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

    private let nameField = UITextField()
    private let mottoField = UITextField()
    private let datePicker = UIDatePicker()
    private let startButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    var onChallengeCreated: ((Challenge) -> Void)?

    init(viewModel: NewChallengeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        nameField.placeholder = "Pompejská Novéna"
        nameField.text = "Pompejská Novéna"
        nameField.isEnabled = false
        nameField.borderStyle = .roundedRect

        mottoField.placeholder = "Tvoj úmysel (voliteľné)"
        mottoField.borderStyle = .roundedRect
        
        let startDateLabel = UILabel()
        startDateLabel.text = "Počiatočný dátum"
        startDateLabel.font = .systemFont(ofSize: 16, weight: .medium)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        
        [startButton, cancelButton].forEach { button in
            button.layer.cornerRadius = 5
            button.backgroundColor = .systemPurple
            button.setTitleColor(.white, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.setTitleColor(.black, for: .normal)
        }

        startButton.setTitle("Začať novénu", for: .normal)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        cancelButton.setTitle("Zrušiť", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        // Use a container stack for date label + picker
        let dateStack = UIStackView(arrangedSubviews: [startDateLabel, datePicker])
        dateStack.axis = .horizontal
        dateStack.spacing = 4
        dateStack.distribution = .equalSpacing

        let stack = UIStackView(arrangedSubviews: [
            nameField,
            mottoField,
            dateStack,
            UIView(), // Spacer
            startButton,
            cancelButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc private func startTapped() {
        viewModel.name = nameField.text ?? ""
        viewModel.note = mottoField.text ?? ""
        viewModel.startDate = datePicker.date

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
}
