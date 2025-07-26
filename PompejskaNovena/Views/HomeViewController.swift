//
//  HomeViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class HomeViewController: UIViewController {
    public var buttonClickedCallback: (()-> Void)?
    
    private let viewModel: ChallengeProgressViewModel

    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let percentageLabel = UILabel()
    private let daysLabel = UILabel()
    private let progressContainer = UIView()
    private let infoLabel = UILabel()
    private let noteLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let startButton = UIButton()
    private let restartButton = UIButton()
    private let completedLabel = UILabel()

    init(viewModel: ChallengeProgressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemPurple
        setupUI()
    }
    
    public func setupUI()->Void {
        if let challenge = viewModel.getChallenge() {
            infoLabel.text = "Pompejská novéna na úmysel:"
            infoLabel.textColor = .black
            infoLabel.font = UIFont(name: "Arial", size: 20)
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(infoLabel)
            
            noteLabel.text = challenge.note
            noteLabel.textColor = .black
            noteLabel.font = UIFont(name: "Arial", size: 16)
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            noteLabel.numberOfLines = 0
            noteLabel.lineBreakMode = .byWordWrapping
            noteLabel.textAlignment = .center
            view.addSubview(noteLabel)
            
            progressContainer.translatesAutoresizingMaskIntoConstraints = false
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            percentageLabel.font = .systemFont(ofSize: 18, weight: .medium)
            percentageLabel.textAlignment = .center
            percentageLabel.textColor = .black
            view.addSubview(percentageLabel)
            
            daysLabel.translatesAutoresizingMaskIntoConstraints = false
            daysLabel.font = .systemFont(ofSize: 18, weight: .medium)
            daysLabel.textAlignment = .center
            daysLabel.textColor = .black
            view.addSubview(daysLabel)
            
            progressContainer.clipsToBounds = true
            progressContainer.layer.cornerRadius = 10
            progressContainer.backgroundColor = .systemGray5

            progressBar.translatesAutoresizingMaskIntoConstraints = false
            progressBar.trackTintColor = .clear // transparent, since container is the background
            progressBar.progressTintColor = .systemGreen
            progressBar.layer.cornerRadius = 10
            progressBar.clipsToBounds = true
            view.addSubview(progressBar)

            view.addSubview(progressContainer)
            progressContainer.addSubview(progressBar)
            
            completedLabel.textColor = .black
            completedLabel.font = UIFont(name: "Arial", size: 16)
            completedLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(completedLabel)
            
            restartButton.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
            restartButton.translatesAutoresizingMaskIntoConstraints = false
            restartButton.layer.cornerRadius = 7
            restartButton.setTitle("Začať odznovu", for: .normal)
            restartButton.setTitleColor(.black, for: .normal)
            restartButton.setTitleColor(.gray, for: .selected)
            restartButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)
            view.addSubview(restartButton)
            
            NSLayoutConstraint.activate([
                infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                
                noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                noteLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
                
                progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                progressContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                progressContainer.heightAnchor.constraint(equalToConstant: 20),

                progressBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
                progressBar.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
                progressBar.topAnchor.constraint(equalTo: progressContainer.topAnchor),
                progressBar.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),

                percentageLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 12),
                percentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
                completedLabel.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 20),
                completedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                daysLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 25),
                daysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
        } else {
            welcomeLabel.text = "Vitajte v aplikácii"
            welcomeLabel.textColor = .black
            welcomeLabel.font = UIFont(name: "Arial", size: 20)
            welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(welcomeLabel)
            
            startButton.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
            startButton.translatesAutoresizingMaskIntoConstraints = false
            startButton.layer.cornerRadius = 10
            startButton.setTitle("Začať pompejskú novénu", for: .normal)
            startButton.setTitleColor(.black, for: .normal)
            startButton.setTitleColor(.gray, for: .selected)
            startButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)
            view.addSubview(startButton)
            
            NSLayoutConstraint.activate([
                welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                startButton.heightAnchor.constraint(equalToConstant: 40),
                startButton.widthAnchor.constraint(equalToConstant: 300),
                startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        }
        
        updateProgress()
    }
    
    private func updateProgress() {
        let progress = viewModel.currentProgress()
        progressBar.setProgress(Float(progress.percentage), animated: true)
        percentageLabel.text = "\(Int(progress.percentage * 100))% hotovo"
        
        completedLabel.text = "Pomodlených \(progress.completed) ružencov"
        daysLabel.text = "\(Int(progress.passedDays + 1)) deň novény z \(progress.totalDays)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProgress()
    }
    
    @objc private func didPushButton() {
        self.buttonClickedCallback?()
    }
}

