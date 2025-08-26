//
//  HomeViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class HomeViewController: UIViewController {
    public var buttonClickedCallback: (()-> Void)?
    
    private let progressView: ProgressView
    private let viewModel: ChallengeProgressViewModel
    private let infoLabel = UILabel()
    private let noteLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let startButton = UIButton()
    private let restartButton = UIButton()

    init(viewModel: ChallengeProgressViewModel) {
        self.viewModel = viewModel
        progressView = ProgressView()
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            restartButton.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
            restartButton.translatesAutoresizingMaskIntoConstraints = false
            restartButton.layer.cornerRadius = 7
            restartButton.setTitle("Začať odznovu", for: .normal)
            restartButton.setTitleColor(.black, for: .normal)
            restartButton.setTitleColor(.gray, for: .selected)
            restartButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)
            view.addSubview(restartButton)
            
            progressView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(progressView)
            
            NSLayoutConstraint.activate([
                infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                
                noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                noteLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),

                restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                progressView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 150),
                progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = viewModel.currentProgress()
    }
    
    @objc private func didPushButton() {
        self.buttonClickedCallback?()
    }
}

