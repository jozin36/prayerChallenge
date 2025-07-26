//
//  HomeCoordinator.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 25/07/2025.
//


import UIKit
import CoreData

final class HomeCoordinator {
    let navigationController: UINavigationController
    private let context: NSManagedObjectContext
    private var viewController: HomeViewController?
    
    // Keep reference to modal coordinator or view controller if needed
    //private var homeViewModel: HomeViewModel?

    // MARK: - Init
    init(navigationController: UINavigationController, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.navigationController = navigationController
        self.context = context
    }
    
    // MARK: - Start
    func start() {
        let vm = ChallengeProgressViewModel(context: self.context)
        let vc = HomeViewController(viewModel: vm)
        
        vc.buttonClickedCallback = buttonClicked
        navigationController.pushViewController(vc, animated: true)
        
        self.viewController = vc
    }
    
    func buttonClicked()-> Void {
        presentNewChallengeModal()
    }
    
    func refreshChallenge()-> Void {
        self.viewController?.view.subviews.forEach { $0.removeFromSuperview() }
        self.viewController?.setupUI()
    }
    
    func presentNewChallengeModal() {
        let vm = NewChallengeViewModel(context: context)
        let vc = NewChallengeViewController(viewModel: vm)
        vc.onChallengeCreated = { challenge in
            //self.navigationController.tabBarController?.selectedIndex = 1
            CoreDataManager.shared.setCurrentChallenge(challenge: challenge)
            self.refreshChallenge()
        }
        navigationController.present(vc, animated: true)
    }
}
