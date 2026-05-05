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
        controller.title = "O aplikácii"
        
        return controller
    }()

    init(window: UIWindow, context: NSManagedObjectContext) {
        self.window = window
        self.context = context
    }

    func start() {
        self.mainTabBarController = MainViewController()
        let tabBar = mainTabBarController
        configureNavigationAppearance()
        
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
        
        let settingsNav = UINavigationController()
        settingsNav.tabBarItem = UITabBarItem(title: "Nastavenia", image: UIImage(systemName: "gearshape"), tag: 2)
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNav)
        settingsCoordinator.start()
        
        self.mainTabBarController!.setViewControllers([homeNav, calendarNav, rosaryNav, settingsNav, aboutNav], animated: true)

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    private func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ColorProvider.shared.backgroundColour
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: AppDesign.Font.headline()
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: AppDesign.Font.hero()
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = ColorProvider.shared.primaryColour
    }
    
}
