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
    
    required init() {
        self.signUpViewController = SignUpViewController()
        self.navigationController = UINavigationController(rootViewController: signUpViewController)
    }
    
    func start() {
        self.signUpViewController.viewModel = SignUpViewModel(coordinator: self)
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
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}
