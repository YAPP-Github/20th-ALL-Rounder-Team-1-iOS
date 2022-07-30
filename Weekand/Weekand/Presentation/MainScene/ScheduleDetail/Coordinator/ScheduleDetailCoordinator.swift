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
    var scheduleId: String
    var requestDate: Date
    
    required init(navigationController: UINavigationController, scheduleId: String, isStatusEditing: Bool, requestDate: Date) {
        self.scheduleDetailUseCase = ScheduleDetailUseCase()
        self.scheduleDetailViewController = ScheduleDetailViewController(isStatusEditing: isStatusEditing,
                                                                         requestDate: requestDate)
        self.navigationController = navigationController
        self.scheduleId = scheduleId
        self.requestDate = requestDate
    }
    
    func start() {
        let scheduleDetailViewModel = ScheduleDetailViewModel(coordinator: self, scheduleDetailUseCase: scheduleDetailUseCase)
        self.scheduleDetailViewController.viewModel = scheduleDetailViewModel
        scheduleDetailViewModel.schedule(scheduleId: self.scheduleId, requestDate: self.requestDate)
        self.navigationController.pushViewController(scheduleDetailViewController, animated: true)
    }
    
    func showToastMessage(text: String) {
        scheduleDetailViewController.showToast(message: text)
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
