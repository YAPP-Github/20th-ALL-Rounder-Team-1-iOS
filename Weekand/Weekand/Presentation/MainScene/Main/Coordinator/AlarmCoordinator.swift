//
//  AlarmCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/29.
//

import UIKit

import UIKit

class AlarmCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .main
    var alarmViewController: AlarmViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.alarmViewController = AlarmViewController()
    }
    
    func start() {
        self.alarmViewController.viewModel = AlarmViewModel(coordinator: self)
        self.navigationController.pushViewController(alarmViewController, animated: true)
    }
    

    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}

extension AlarmCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
