//
//  SettingsCoordinator.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UIKit

final class SettingsCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        vc.title = "Nastavenia"
        navigationController.viewControllers = [vc]
    }
}
