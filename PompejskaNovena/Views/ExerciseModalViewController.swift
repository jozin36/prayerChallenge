import UIKit

final class ExerciseModalViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel: ExerciseModalViewModel
    var onSave: (() -> Void)?

    // MARK: - UI
    private let stackView = UIStackView()

    // MARK: - Init
    init(viewModel: ExerciseModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Log Exercises"
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
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for type in viewModel.sortedExerciseTypes {
            let toggle = createRow(for: type)
            stackView.addArrangedSubview(toggle)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()] // or .large()
            sheet.prefersGrabberVisible = true
        }

        setupButtons()
    }

    private func createRow(for type: String) -> UIStackView {
        let label = UILabel()
        label.text = type
        label.font = .systemFont(ofSize: 17)

        let toggle = UISwitch()
        toggle.isOn = viewModel.state(for: type)
        toggle.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.toggleState(for: type)
        }), for: .valueChanged)

        let row = UIStackView(arrangedSubviews: [label, toggle])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        return row
    }

    private func setupButtons() {
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = save
    }

    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        viewModel.save()
        onSave?()
        dismiss(animated: true)
    }
}
