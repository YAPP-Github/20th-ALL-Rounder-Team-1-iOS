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
    var schedule: ScheduleSummary
    
    required init(navigationController: UINavigationController, schedule: ScheduleSummary, isStatusEditing: Bool) {
        self.scheduleDetailUseCase = ScheduleDetailUseCase()
        self.scheduleDetailViewController = ScheduleDetailViewController(isStatusEditing: isStatusEditing)
        self.navigationController = navigationController
        self.schedule = schedule
    }
    
    func start() {
        let scheduleDetailViewModel = ScheduleDetailViewModel(coordinator: self, scheduleDetailUseCase: scheduleDetailUseCase)
        self.scheduleDetailViewController.viewModel = scheduleDetailViewModel
        scheduleDetailViewModel.schedule(scheduleId: schedule.scheduleId, requestDate: schedule.dateStart)
        self.navigationController.pushViewController(scheduleDetailViewController, animated: true)
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
