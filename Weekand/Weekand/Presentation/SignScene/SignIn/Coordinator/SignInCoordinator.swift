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
    var signInUseCase: SignInUseCase
    var type: CoordinatorType = .signIn
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signInUseCase = SignInUseCase()
        self.signInViewController = SignInViewController()
    }
    
    func start() {
        self.signInViewController.viewModel = SignInViewModel(coordinator: self, signInUseCase: signInUseCase)
        self.navigationController.pushViewController(signInViewController, animated: true)
    }
    
    func showMainScene() {
        let mainCoordinator = MainCoordinator(navigationController: self.navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    func presentPasswordFindScene() {
        let passwordFindCoordinator = PasswordFindCoordinator(signInUseCase: signInUseCase)
        childCoordinators.append(passwordFindCoordinator)
        passwordFindCoordinator.finishDelegate = self
        navigationController.present(passwordFindCoordinator.navigationController, animated: true, completion: nil)
        passwordFindCoordinator.start()
    }
    
    func showToastMessage(text: String) {
        signInViewController.showToast(message: text)
    }
}

extension SignInCoordinator: CoordinatorDidFinishDelegate {
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
    }
}
