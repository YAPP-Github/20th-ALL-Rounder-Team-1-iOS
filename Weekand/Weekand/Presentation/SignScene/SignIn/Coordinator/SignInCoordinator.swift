//
//  SignInCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class SignInCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var signInViewController: SignInViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signInViewController = SignInViewController()
    }
    
    func start() {
        // viewModel
        self.navigationController.viewControllers = [self.signInViewController]
    }
    
}
