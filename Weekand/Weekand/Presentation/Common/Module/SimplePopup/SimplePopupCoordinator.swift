//
//  AuthPopupCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import UIKit

class SimplePopupCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var simplePopupViewController: SimplePopupViewController
    var dismissParentCoordinator: Bool
    var type: CoordinatorType = .simplePopup
    
    required init(titleText: String, informText: String, dismissParentCoordinator: Bool) {
        self.simplePopupViewController = SimplePopupViewController(
                                            titleText: titleText,
                                            informText: informText)
        self.dismissParentCoordinator = dismissParentCoordinator
        self.navigationController = UINavigationController(rootViewController: simplePopupViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
    }
    
    func start() {
        self.simplePopupViewController.viewModel = SimplePopupViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
        if self.dismissParentCoordinator {
            self.finishDelegate?.childDidFinish(self)
        }
    }
}
