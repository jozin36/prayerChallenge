import UIKit

final class ExerciseModalViewController: UIViewController {
    private let viewModel: ExerciseModalViewModel
    var onSave: (() -> Void)?

    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let helperLabel = UILabel()
    private let toggleStack = UIStackView()

    init(viewModel: ExerciseModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = nil
        navigationItem.title = nil
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = ColorProvider.shared.backgroundColour

        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, helperLabel])
        headerStack.axis = .vertical
        headerStack.spacing = AppDesign.Spacing.xs
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = dayTitle()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        dateLabel.text = formatDate(viewModel.getDate())
        dateLabel.font = AppDesign.Font.body()
        dateLabel.textColor = ColorProvider.shared.mutedTextColour

        helperLabel.text = "Zapíšte si ružence"
        helperLabel.font = .systemFont(ofSize: 15)
        helperLabel.textColor = ColorProvider.shared.mutedTextColour
        helperLabel.numberOfLines = 0

        toggleStack.axis = .vertical
        toggleStack.spacing = 0
        toggleStack.translatesAutoresizingMaskIntoConstraints = false

        for (index, type) in viewModel.sortedExerciseTypes.enumerated() {
            toggleStack.addArrangedSubview(createRow(for: type))

            if index < viewModel.sortedExerciseTypes.count - 1 {
                toggleStack.addArrangedSubview(makeDivider())
            }
        }

        contentStack.addArrangedSubview(headerStack)
        contentStack.setCustomSpacing(AppDesign.Spacing.lg, after: headerStack)
        contentStack.addArrangedSubview(toggleStack)

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppDesign.Spacing.lg),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppDesign.Spacing.lg),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppDesign.Spacing.lg),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.xl)
        ])

        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = AppDesign.Radius.large
        }
    }

    private func createRow(for type: String) -> UIView {
        let label = UILabel()
        label.text = displayName(for: type)
        label.font = AppDesign.Font.body()
        label.textColor = .label
        label.numberOfLines = 0

        let toggle = UISwitch()
        toggle.isOn = viewModel.state(for: type)
        toggle.onTintColor = ColorProvider.shared.firstHalfProgressBarColor
        toggle.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.toggleState(for: type)
            self?.viewModel.save()
            self?.onSave?()
        }), for: .valueChanged)

        let row = UIStackView(arrangedSubviews: [label, toggle])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        row.spacing = AppDesign.Spacing.md
        row.layoutMargins = UIEdgeInsets(top: AppDesign.Spacing.md, left: 0, bottom: AppDesign.Spacing.md, right: 0)
        row.isLayoutMarginsRelativeArrangement = true

        return row
    }

    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = ColorProvider.shared.strokeColour
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        return divider
    }

    private func dayTitle() -> String {
        guard let dayNumber = viewModel.getNovenaDayNumber() else {
            return "Deň"
        }

        return "Deň \(dayNumber)"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "sk_SK")
        formatter.dateFormat = "dd. MMMM yyyy"
        return formatter.string(from: date)
    }

    private func displayName(for type: String) -> String {
        switch type {
        case "Radostný":
            return "Radostný ruženec"
        case "Bolestný":
            return "Bolestný ruženec"
        case "Slávnostný":
            return "Slávnostný ruženec"
        default:
            return type
        }
    }
}
