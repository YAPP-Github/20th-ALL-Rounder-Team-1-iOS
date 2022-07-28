//
//  ScheduleDetailCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation
import UIKit

class ScheduleDetailCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleDetailViewController: ScheduleDetailViewController
    var scheduleDetailUseCase: ScheduleDetailUseCase
    var type: CoordinatorType = .scheduleDetail
    
    required init() {
        self.scheduleDetailUseCase = ScheduleDetailUseCase()
        self.scheduleDetailViewController = ScheduleDetailViewController()
        self.navigationController = UINavigationController(rootViewController: scheduleDetailViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.scheduleDetailViewController.viewModel = ScheduleDetailViewModel(coordinator: self, scheduleDetailUseCase: scheduleDetailUseCase)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}

extension ScheduleDetailCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
