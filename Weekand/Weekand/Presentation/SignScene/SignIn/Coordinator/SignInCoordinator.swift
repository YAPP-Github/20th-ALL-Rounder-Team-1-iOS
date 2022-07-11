//
//  SignInCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class SignInCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
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
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
    func showMainScene() {
        let mainCoordinator = MainCoordinator(navigationController: self.navigationController)
        mainCoordinator.finishDelegate = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    func presentPasswordFindScene() {
        let passwordFindCoordinator = PasswordFindCoordinator(signInUseCase: signInUseCase)
        passwordFindCoordinator.finishDelegate = self
        childCoordinators.append(passwordFindCoordinator)
        navigationController.present(passwordFindCoordinator.navigationController, animated: true, completion: nil)
        passwordFindCoordinator.start()
    }
    
    func showToastMessage() {
        signInViewController.showToast(message: "이메일·비밀번호가 일치하지 않습니다.")
    }
}

extension SignInCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
