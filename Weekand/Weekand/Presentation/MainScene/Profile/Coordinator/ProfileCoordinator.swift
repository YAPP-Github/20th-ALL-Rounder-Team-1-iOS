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
    var myProfileViewController: MyProfileViewController
    var type: CoordinatorType = .profile
    
    
    required init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.myProfileViewController = MyProfileViewController()
    }
    
    func start() {
        self.myProfileViewController.viewModel = MyProfileViewModel(coordinator: self)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.pushViewController(myProfileViewController, animated: true)
    }
    
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
