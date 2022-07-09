//
//  AuthPopupCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import UIKit

class SimplePopupCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var simplePopupViewController: SimplePopupViewController
    var type: CoordinatorType = .simplePopup
    
    required init(titleText: String, informText: String) {
        self.simplePopupViewController = SimplePopupViewController(titleText: titleText, informText: informText)
        self.navigationController = UINavigationController(rootViewController: simplePopupViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
    }
    
    func start() {
        self.simplePopupViewController.viewModel = SimplePopupViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}
