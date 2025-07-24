//
//  HomeViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class HomeViewController: UIViewController {
    public var buttonClickedCallback: (()-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemPurple
        
        let label = UILabel()
        label.text = "Vitajte v aplikácii"
        label.textColor = .black
        label.font = UIFont(name: "Arial", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        let startButton = UIButton()
        startButton.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.layer.cornerRadius = 5
        startButton.setTitle("Začať pompejskú novénu", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.gray, for: .selected)
        startButton.addTarget(self, action: #selector(self.didPushButton), for: .touchUpInside)
        
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            startButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 300),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didPushButton() {
        self.buttonClickedCallback?()
        
        print("Button clicked")
    }
}
