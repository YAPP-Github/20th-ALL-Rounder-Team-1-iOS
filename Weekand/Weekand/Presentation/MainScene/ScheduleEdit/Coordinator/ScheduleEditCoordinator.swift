//
//  ScheduleEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import Foundation
import UIKit

class ScheduleEditCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleEditViewController: ScheduleEditViewController
    var type: CoordinatorType = .scheduleEdit
    
    required init() {
        self.scheduleEditViewController = ScheduleEditViewController()
        self.navigationController = UINavigationController(rootViewController: scheduleEditViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.scheduleEditViewController.viewModel = ScheduleEditViewModel(coordinator: self)
    }
    
    func presentRepeatSheet() {
        
    }
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
