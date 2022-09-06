//
//  WarningPopupCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import UIKit

class ResignWarningPopupCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var resignWarningPopupViewController: ResignWarningPopupViewController
    var profileUseCase: ProfileUseCase
    var type: CoordinatorType = .warningPopup
    
    required init(useCase: ProfileUseCase) {
        self.resignWarningPopupViewController = ResignWarningPopupViewController()
        self.navigationController = UINavigationController(rootViewController: resignWarningPopupViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController.modalTransitionStyle = .crossDissolve
        self.profileUseCase = useCase
    }
    
    func start() {
        self.resignWarningPopupViewController.viewModel = WarningPopupViewModel(coordinator: self, useCase: profileUseCase)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}
