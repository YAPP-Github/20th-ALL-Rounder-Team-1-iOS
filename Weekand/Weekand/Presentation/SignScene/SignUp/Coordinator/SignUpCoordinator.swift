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
    var type: CoordinatorType = .signUp
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.signUpViewController = SignUpViewController()
    }
    
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self)
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func pushAddInformationViewController() {
        let signUpAddInformationViewController = SignUpAddInfomationViewController()
        self.navigationController.pushViewController(signUpAddInformationViewController, animated: true)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}
