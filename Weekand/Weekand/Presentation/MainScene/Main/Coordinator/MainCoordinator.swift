//
//  MainCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import UIKit

class MainCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .main
    var mainViewController: MainViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainViewController = MainViewController()
    }
    
    func start() {
        self.mainViewController.viewModel = MainViewModel(coordinator: self)
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
    func showCategoryScene() {
        let categoryCoordinator = CategoryCoordinator(navigationController: self.navigationController)
        categoryCoordinator.finishDelegate = self
        childCoordinators.append(categoryCoordinator)
        categoryCoordinator.start()
    }
    
    func pushAlarmViewController() {
        let alarmViewController = AlarmViewController()
        alarmViewController.viewModel = AlarmViewModel()
        self.navigationController.pushViewController(alarmViewController, animated: true)
    }
        
    // TODO: 검색 화면 구현 후 개발
    func showSearchScene() {
        print(#function)
    }
}

extension MainCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.popToRootViewController(animated: true)
    }
}
