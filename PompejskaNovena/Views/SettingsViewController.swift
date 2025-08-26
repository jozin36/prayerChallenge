//
//  SettingsViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UIKit

class SettingsViewController: UIViewController {

    private var viewModel: SettingsViewModel
    private let notificationSwitch = UISwitch()
    private let switchLabel = UILabel()
    
    private let stackView = UIStackView()
    private var timeButtons: [UIButton] = []
    private var reminderStack = UIStackView()
    private var toggleButtons: [UISwitch] = []
    private var reminderTimes: [Date] = {
        let stored = UserDefaults.standard.array(forKey: "reminderTimes") as? [Double]
            
        if let stored = stored {
            return stored.map { Date(timeIntervalSince1970: $0) }
        } else {
            // Default times: 07:00, 15:00, 18:00
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
        }
    }()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Nastavenia"
        
        setupUI()
    }
    
    private func setupReminderSection()-> UIStackView {
        let remindersLabel = UILabel()
        remindersLabel.text = "Upozornenia cez deň:"
        remindersLabel.font = .systemFont(ofSize: 17)

        // Create vertical stack for reminder buttons
        reminderStack.axis = .vertical
        reminderStack.spacing = 12
        let toggleButtonsState = UserDefaults.standard.array(forKey: "reminderToggleButtons") as? [Bool]

        for (index, button) in timeButtons.enumerated() {
            let icon = UIImageView(image: UIImage(systemName: "clock"))
            icon.tintColor = .gray
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            button.setTitle(reminderTimes[index].formatted(date: .omitted, time: .shortened), for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            button.contentHorizontalAlignment = .left
            button.isHidden = !notificationSwitch.isOn
            
            let toggleSwitch = toggleButtons[index]
            toggleSwitch.addTarget(self, action: #selector(didSwitchRemainder), for: .valueChanged)
            
            toggleSwitch.isOn = toggleButtonsState != nil ? toggleButtonsState![index] : false

            let row = UIStackView(arrangedSubviews: [icon, button, toggleSwitch])
            row.axis = .horizontal
            row.spacing = 12
            row.alignment = .center
            reminderStack.addArrangedSubview(row)
        }

        // Wrap everything in a container stack
        let container = UIStackView(arrangedSubviews: [reminderStack])
        container.axis = .vertical
        container.spacing = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }


    private func setupUI() {
        // Switch row
        switchLabel.text = "Zapnúť denné upozornenia"
        switchLabel.font = .systemFont(ofSize: 17)
        self.view.backgroundColor = ColorProvider.shared.backgroundColour
        
        let switchRow = UIStackView(arrangedSubviews: [switchLabel, notificationSwitch])
        switchRow.axis = .horizontal
        switchRow.distribution = .equalSpacing
        
        notificationSwitch.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        let isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        notificationSwitch.isOn = isOn
        
        for index in 0..<3 {
            let button = UIButton(type: .system)
            button.setTitle(timeString(for: reminderTimes[index]), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(timeButtonTapped(_:)), for: .touchUpInside)
            //button.isHidden = index > 1
            timeButtons.append(button)
            
            let toogleSwitch = UISwitch()
            toggleButtons.append(toogleSwitch)
        }
        
        // Main stack
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(switchRow)
        
        let remaindersContainer = setupReminderSection()
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(remaindersContainer)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func didSwitchRemainder() {
        self.saveReminderTimes()
        self.scheduleNotifications()
    }

    @objc private func didToggleSwitch() {
        let isOn = notificationSwitch.isOn
        saveSwitchState(isOn)
        self.reminderStack.isHidden = !isOn
        
        if isOn {
            requestNotificationPermissionIfNeeded()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    private func saveReminderTimes() {
        let timeStamps = reminderTimes.map { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(timeStamps, forKey: "reminderTimes")
        
        let boolVals = toggleButtons.map( {$0.isOn } )
        UserDefaults.standard.set(boolVals, forKey: "reminderToggleButtons")
    }

    private func saveSwitchState(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "notificationsEnabled")
    }

    private func requestNotificationPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus != .authorized else { return }

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("✅ Notification permission granted")
                } else {
                    print("❌ Permission denied: \(error?.localizedDescription ?? "none")")
                }
            }
        }
    }

    @objc private func timeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.date = reminderTimes[index]
        picker.isHidden = false
        
        let alert = UIAlertController(title: "Zvoľte čas", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            picker.heightAnchor.constraint(equalToConstant: 170)
        ])

        alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel))
        alert.addAction(UIAlertAction(title: "Nastaviť", style: .default, handler: { _ in
            self.reminderTimes[index] = picker.date
            self.timeButtons[index].setTitle(self.timeString(for: picker.date), for: .normal)
            self.saveReminderTimes()
            self.scheduleNotifications()
        }))
        
        present(alert, animated: true)
    }

    private func timeString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Optional: Call this when user leaves screen or presses "Save"
    func scheduleNotifications() {
        guard notificationSwitch.isOn else { return }

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        for (index, date) in reminderTimes.enumerated() {
            if (toggleButtons[index].isOn) {
                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
                
                let content = UNMutableNotificationContent()
                content.title = "Pompejská novéna"
                content.body = "Nezabudni sa pomodliť ruženec!"
                content.sound = .default
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: "dailyReminder\(index)", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
