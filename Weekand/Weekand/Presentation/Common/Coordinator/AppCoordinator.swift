//
//  AppCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType = .app
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        if UserDefaults.standard.bool(forKey: "autoSign") {
            showMainScene()
        } else {
            showWelcomeScene()
        }
    }
    
    private func showWelcomeScene() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: self.navigationController)
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showMainScene() {
        let mainCoordinator = MainCoordinator(navigationController: self.navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}

extension AppCoordinator {
//    func setNotificationCenter() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(showWelcomSceneFromLogout(_:)),
//                                               name: NSNotification.Name("showWeclomeScene"),
//                                               object: nil)
//    }
//
//    @objc func showWelcomSceneFromLogout(_ notification: Notification) {
//        self.navigationController.setViewControllers([], animated: false)
//        self.showWelcomeScene()
//    }
    
}

extension AppCoordinator: UINavigationControllerDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let profileViewController = fromViewController as? ProfileViewController,
           let profileCoordinator = profileViewController.viewModel?.coordinator as? ProfileCoordinator {
            childDidFinish(profileCoordinator)
        }
        
        if let signInViewController = fromViewController as? SignInViewController,
           let signInCoordinator = signInViewController.viewModel?.coordinator as? SignInCoordinator {
            childDidFinish(signInCoordinator)
        }
    }
}
