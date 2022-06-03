//
//  SignUpCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class SignUpCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var signUpViewController: SignUpViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = SignUpViewController()
    }
    
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self)
        self.navigationController.viewControllers = [self.signUpViewController]
    }
    
}
