//
//  AppCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/31.
//

import Foundation
import UIKit

class WelcomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var welcomeViewController: WelcomeViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.welcomeViewController = WelcomeViewController()
    }
    
    func start() {
        // 자동 로그인 구현
        
        self.welcomeViewController.viewModel = WelcomeViewModel(coordinator: self)
        self.navigationController.viewControllers = [self.welcomeViewController]
    }
    
    func showSignInScene() {
        let signInCoordinator = SignInCoordinator(navigationController: self.navigationController)
        signInCoordinator.start()
        childCoordinators.append(signInCoordinator)
    }
    
    func showSignUpScene() {
        let signUpCoordinator = SignUpCoordinator(navigationController: self.navigationController)
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)
    }
}
