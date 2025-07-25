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
    private let challenge: Challenge?
    private let context: NSManagedObjectContext
    
    // Keep reference to modal coordinator or view controller if needed
    //private var homeViewModel: HomeViewModel?

    // MARK: - Init
    init(navigationController: UINavigationController, challenge: Challenge?, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.navigationController = navigationController
        self.challenge = challenge
        self.context = context
    }
    
    // MARK: - Start
    func start() {
        let vm = ChallengeProgressViewModel(challenge: challenge, context: self.context)
        let vc = HomeViewController(viewModel: vm)
        
        vc.buttonClickedCallback = buttonClicked
        navigationController.pushViewController(vc, animated: true)
    }
    
    func buttonClicked()-> Void {
        presentNewChallengeModal()
    }
    
    func presentNewChallengeModal() {
        let vm = NewChallengeViewModel(context: context)
        let vc = NewChallengeViewController(viewModel: vm)
        vc.onChallengeCreated = { challenge in
            self.navigationController.tabBarController?.selectedIndex = 1
            //self?.refreshChallenge(challenge)
        }
        navigationController.present(vc, animated: true)
    }

}
