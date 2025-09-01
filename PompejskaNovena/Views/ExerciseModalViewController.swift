import UIKit

final class ExerciseModalViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: ExerciseModalViewModel
    var onSave: (() -> Void)?
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    // MARK: - UI
    private let toggleStack = UIStackView()

    // MARK: - Init
    init(viewModel: ExerciseModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = self.viewModel.getDate().formatted(date: .long, time: .omitted)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = ColorProvider.shared.backgroundColour
        
        toggleStack.axis = .vertical
        toggleStack.spacing = 20
        toggleStack.translatesAutoresizingMaskIntoConstraints = false

        for type in viewModel.sortedExerciseTypes {
            let toggle = createRow(for: type)
            toggleStack.addArrangedSubview(toggle)
        }

        // Spacer to push buttons down
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [saveButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 40
        buttonStack.distribution = .fillEqually

        saveButton.setTitle("Hotovo", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        [saveButton].forEach { button in
            button.layer.cornerRadius = 10
            button.backgroundColor = ColorProvider.shared.buttonColour
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.setTitleColor(.label, for: .normal)
        }
        
        let mainStack = UIStackView(arrangedSubviews: [toggleStack, spacer, buttonStack])
                mainStack.axis = .vertical
                mainStack.spacing = 24
                mainStack.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()] // or .large()
            sheet.prefersGrabberVisible = true
        }
    }

    private func createRow(for type: String) -> UIStackView {
        let label = UILabel()
        label.text = type
        label.font = .systemFont(ofSize: 17)

        let toggle = UISwitch()
        toggle.isOn = viewModel.state(for: type)
        toggle.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.toggleState(for: type)
            self?.viewModel.save()
            self?.onSave?()
        }), for: .valueChanged)
        
        toggle.onTintColor = ColorProvider.shared.firstHalfProgressBarColor

        let row = UIStackView(arrangedSubviews: [label, toggle])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        return row
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        dismiss(animated: true)
    }
}
