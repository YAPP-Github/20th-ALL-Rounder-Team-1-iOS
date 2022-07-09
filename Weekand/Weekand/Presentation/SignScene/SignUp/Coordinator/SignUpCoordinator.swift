//
//  SignUpCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class SignUpCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var signUpViewController: SignUpViewController
    var signUpUseCase: SignUpUseCase
    var type: CoordinatorType = .signUp
    
    required init() {
        self.signUpViewController = SignUpViewController()
        self.signUpUseCase = SignUpUseCase()
        self.navigationController = UINavigationController(rootViewController: signUpViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
    }
    
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self, signUpUseCase: signUpUseCase)
    }
    
    func pushAddInformationViewController() {
        let signUpAddInformationViewController = SignUpAddInfomationViewController()
        signUpAddInformationViewController.viewModel = SignUpAddInfomationViewModel(coordinator: self)
        self.navigationController.pushViewController(signUpAddInformationViewController, animated: true)
    }
    
    func pushTermsViewController() {
        let signUpTermsViewController  = SignUpTermsViewController()
        signUpTermsViewController.viewModel = SignUpTermsViewModel(coordinator: self)
        self.navigationController.pushViewController(signUpTermsViewController, animated: true)
    }
    
    func presentPopViewController() {
        let authPopupCoordinator = AuthPopupCoordinator()
        authPopupCoordinator.finishDelegate = self
        childCoordinators.append(authPopupCoordinator)
        navigationController.present(authPopupCoordinator.navigationController, animated: true, completion: nil)
        authPopupCoordinator.start()
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}

extension SignUpCoordinator: CoordinatorDidFinishDelegate {
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
