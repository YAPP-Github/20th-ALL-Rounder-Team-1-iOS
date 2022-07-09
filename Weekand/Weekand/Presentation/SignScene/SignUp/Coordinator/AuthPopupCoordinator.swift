//
//  AuthPopupCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import UIKit

class AuthPopupCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var authPopupViewController: AuthPopupViewController
    var type: CoordinatorType = .authPopup
    
    required init() {
        self.authPopupViewController = AuthPopupViewController()
        self.navigationController = UINavigationController(rootViewController: authPopupViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
    }
    
    func start() {
        self.authPopupViewController.viewModel = AuthPopupViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
}
