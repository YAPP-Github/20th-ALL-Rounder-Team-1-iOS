//
//  AlertPopupCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/30.
//

import UIKit

class AlertPopupCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var alertPopupViewController: AlertPopupViewController
    var type: CoordinatorType = .warningPopup
    var completionHandler: () -> Void
    
    required init(titleText: String,
                  informText: String,
                  confirmButtonText: String,
                  cancelButtonText: String,
                  completionHandler: @escaping () -> Void) {
        self.alertPopupViewController = AlertPopupViewController(titleText: titleText,
                                                                 informText: informText,
                                                                 confirmButtonText: confirmButtonText,
                                                                 cancelButtonText: cancelButtonText)
        self.navigationController = UINavigationController(rootViewController: alertPopupViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
        self.completionHandler = completionHandler
    }
    
    func start() {
        self.alertPopupViewController.viewModel = AlertPopupViewModel(coordinator: self, completionHandler: self.completionHandler)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}
