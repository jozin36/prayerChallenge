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

    var mainTabBarController: MainViewController?
    var calendarCoordinator: CalendarCoordinator?
    
    private let rosaryNav = {
        let controller = UINavigationController(rootViewController: RosaryViewController())
        controller.tabBarItem.image = UIImage(named: "Rosary")
        controller.title = "Ruženec"
        
        return controller
    }()
    
    private let aboutNav = {
        let controller = UINavigationController(rootViewController: AboutViewController())
        
        controller.tabBarItem.image = UIImage(systemName: "info.circle")
        controller.title = "Info"
        
        return controller
    }()

    init(window: UIWindow, context: NSManagedObjectContext) {
        self.window = window
        self.context = context
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
            context: context
        )
        calendarCoordinator.start()
        self.calendarCoordinator = calendarCoordinator
        
        let homeNav = UINavigationController()
        homeNav.tabBarItem = UITabBarItem(title: "Domov", image: UIImage(systemName: "house"), tag: 1)
        
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNav,
            context: context)
        homeCoordinator.start()

        self.mainTabBarController!.setViewControllers([homeNav, calendarNav, rosaryNav, aboutNav], animated: true)

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
    
}
