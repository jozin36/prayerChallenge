//
//  ViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit
import CoreData

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPurple
        
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .black
        
        //tabBar.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        //tabBar.layer.borderWidth = 1
        tabBar.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
}
