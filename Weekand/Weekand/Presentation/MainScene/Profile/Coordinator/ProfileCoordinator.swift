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
    var profileUseCase: ProfileUseCase
    var type: CoordinatorType = .profile
    var userId: String?
    
    
    required init(navigationController: UINavigationController, userId: String?) {
        
        self.navigationController = navigationController
        self.profileViewController = ProfileViewController()
        self.profileUseCase = ProfileUseCase()
        self.userId = userId
    }
    
    func start() {
        self.profileViewController.viewModel = ProfileViewModel(coordinator: self, useCase: profileUseCase, userId: userId)
        self.navigationController.pushViewController(profileViewController, animated: true)
    }
    
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
