//
//  ProfileCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var profileViewController: ProfileViewController
    var type: CoordinatorType = .profile
    
    required init() {
        self.profileViewController = ProfileViewController()
        self.navigationController = UINavigationController(rootViewController: profileViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.profileViewController.viewModel = ProfileViewModel(coordinator: self)
    }
    
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
