//
//  ViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class MainViewController: UITabBarController {
    
    private let calendarController = {
        let controller = UINavigationController(rootViewController: CalendarViewController())
        controller.tabBarItem.image = UIImage(systemName: "calendar")
        controller.title = "Kalendár"
        
        return controller
    }()
    
    private let rosaryController = {
        let controller = UINavigationController(rootViewController: RosaryViewController())
        controller.tabBarItem.image = UIImage(systemName: "heart.fill")
        controller.title = "Ruženec"
        
        return controller
    }()
    
    private let aboutController = UINavigationController(rootViewController: AboutViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPurple
        
        let viewController = HomeViewController()
        viewController.buttonClickedCallback = buttonClicked
        
        let homeController = UINavigationController(rootViewController: viewController)
        
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.title = "Domov"
        
        
        setViewControllers([homeController, calendarController, rosaryController, aboutController], animated: true)
        
        aboutController.tabBarItem.image = UIImage(systemName: "info.circle")
        aboutController.title = "Info"
        
        
        tabBar.tintColor = .label
    }
    
    func buttonClicked()-> Void {
        self.selectedIndex = 1
    }
}

