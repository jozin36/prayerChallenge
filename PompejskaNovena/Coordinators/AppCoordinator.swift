//
//  AppCoordinator.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 24/07/2025.
//
import UIKit
import CoreData

final class AppCoordinator {
    let window: UIWindow
    let context: NSManagedObjectContext
    let challenge: Challenge?

    var mainTabBarController: MainViewController?
    var calendarCoordinator: CalendarCoordinator?
    
    private let rosaryNav = {
        let controller = UINavigationController(rootViewController: RosaryViewController())
        controller.tabBarItem.image = UIImage(systemName: "heart.fill")
        controller.title = "Ruženec"
        
        return controller
    }()
    
    private let aboutNav = {
        let controller = UINavigationController(rootViewController: AboutViewController())
        
        controller.tabBarItem.image = UIImage(systemName: "info.circle")
        controller.title = "Info"
        
        return controller
    }()

    init(window: UIWindow, context: NSManagedObjectContext, challenge: Challenge?) {
        self.window = window
        self.context = context
        self.challenge = challenge
    }

    func start() {
        self.mainTabBarController = MainViewController()
        let tabBar = mainTabBarController
        
        // Create navigation controllers for each tab
        let calendarNav = UINavigationController()
        calendarNav.tabBarItem = UITabBarItem(title: "Kalendár", image: UIImage(systemName: "calendar"), tag: 0)

        // Start CalendarCoordinator
        let calendarCoordinator = CalendarCoordinator(
            navigationController: calendarNav,
            challenge: challenge,
            context: context
        )
        calendarCoordinator.start()
        self.calendarCoordinator = calendarCoordinator
        
        let viewController = HomeViewController()
        viewController.buttonClickedCallback = buttonClicked
        
        let homeNav = UINavigationController(rootViewController: viewController)
        homeNav.tabBarItem.image = UIImage(systemName: "house")
        homeNav.title = "Domov"

        self.mainTabBarController!.setViewControllers([homeNav, calendarNav, rosaryNav, aboutNav], animated: true)

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
    
    func buttonClicked()-> Void {
        mainTabBarController?.selectedIndex = 1
    }
}
