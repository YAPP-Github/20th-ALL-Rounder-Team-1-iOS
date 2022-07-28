//
//  PasswordCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/28.
//

import Foundation
import UIKit

class PasswordFindCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var passwordFindViewController: PasswordFindViewController
    var signInUseCase: SignInUseCase
    var type: CoordinatorType = .passwordFind
    
    required init(signInUseCase: SignInUseCase) {
        self.passwordFindViewController = PasswordFindViewController()
        self.signInUseCase = signInUseCase
        self.navigationController = UINavigationController(rootViewController: passwordFindViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.passwordFindViewController.viewModel = PasswordFindViewModel(coordinator: self, signInUseCase: signInUseCase)
    }
    
    func presentPopViewController(titleText: String, informText: String, dismissParentCoordinator: Bool) {
        let authPopupCoordinator = SimplePopupCoordinator(
                                        titleText: titleText,
                                        informText: informText,
                                        dismissParentCoordinator: dismissParentCoordinator)
        childCoordinators.append(authPopupCoordinator)
        navigationController.present(authPopupCoordinator.navigationController, animated: true, completion: nil)
        authPopupCoordinator.finishDelegate = self
        authPopupCoordinator.start()
    }
    
    func showToastMessage(text: String) {
        passwordFindViewController.showToast(message: text)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}

extension PasswordFindCoordinator: CoordinatorDidFinishDelegate {
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
