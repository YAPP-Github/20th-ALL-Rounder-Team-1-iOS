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
    var type: CoordinatorType = .passwordFind
    
    required init() {
        self.passwordFindViewController = PasswordFindViewController()
        self.navigationController = UINavigationController(rootViewController: passwordFindViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.passwordFindViewController.viewModel = PasswordFindViewModel(coordinator: self)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}
