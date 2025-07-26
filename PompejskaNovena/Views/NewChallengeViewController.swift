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

    private let nameField = UITextField()
    private let mottoView = UITextView()
    private let placeholderLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let startButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let alertLabel = UILabel()
    private let warningLabel = UILabel()

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
        nameField.text = "Pompejská Novéna na úmysel:"
        nameField.isEnabled = false
        nameField.borderStyle = .none

        //mottoField.placeholder = "Tvoj úmysel (voliteľné)"
        
        mottoView.font = .systemFont(ofSize: 16)
        mottoView.layer.borderWidth = 1
        mottoView.layer.borderColor = UIColor.systemGray4.cgColor
        mottoView.layer.cornerRadius = 7
        mottoView.isScrollEnabled = false // allows it to grow in height naturally
        mottoView.translatesAutoresizingMaskIntoConstraints = false
        mottoView.delegate = self
        
        // Style the placeholder label
        placeholderLabel.text = "Napíš svoj úmysel"
        placeholderLabel.font = mottoView.font
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        mottoView.addSubview(placeholderLabel)
        
        alertLabel.text = "Ak začnete znovu, všetky uložené dáta a história z predošlej novény sa vymažú!"
        alertLabel.textColor = .systemRed
        alertLabel.font = UIFont(name: "Arial", size: 12)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.numberOfLines = 0
        alertLabel.lineBreakMode = .byWordWrapping
        alertLabel.textAlignment = .left
        
        warningLabel.text = "Upozornenie"
        warningLabel.textColor = .systemRed
        warningLabel.font = UIFont(name: "Arial", size: 16)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.numberOfLines = 0
        warningLabel.lineBreakMode = .byWordWrapping
        warningLabel.textAlignment = .center
        
        view.addSubview(alertLabel)

        let startDateLabel = UILabel()
        startDateLabel.text = "Vyberte počiatočný dátum"
        startDateLabel.font = .systemFont(ofSize: 16, weight: .medium)

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "sk_SK")
        datePicker.calendar = Calendar.autoupdatingCurrent
        //datePicker.minimumDate = Date()
        
        [startButton, cancelButton].forEach { button in
            button.layer.cornerRadius = 7
            button.backgroundColor = .systemPurple
            button.setTitleColor(.white, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.setTitleColor(.black, for: .normal)
        }

        startButton.setTitle("Začať novénu", for: .normal)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        cancelButton.setTitle("Zrušiť", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            warningLabel,
            alertLabel,
            nameField,
            mottoView,
            startDateLabel,
            datePicker,
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
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mottoView.heightAnchor.constraint(equalToConstant: 80),
            // Position the placeholder inside the text view
            placeholderLabel.topAnchor.constraint(equalTo: mottoView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: mottoView.leadingAnchor, constant: 5),
            alertLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alertLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
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

    @objc private func startTapped() {
        viewModel.name = "Pompejská Novéna"
        viewModel.note = mottoView.text ?? ""
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

extension NewChallengeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
