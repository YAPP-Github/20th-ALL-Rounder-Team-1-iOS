//
//  CategoryEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/21.
//

import UIKit

class CategoryAddCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .category
    var categoryAddViewController: CategoryEditViewController
    
    required init() {
        self.categoryAddViewController = CategoryEditViewController()
        self.categoryAddViewController.title = "카테고리 추가"
        self.navigationController = UINavigationController(rootViewController: categoryAddViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.categoryAddViewController.viewModel = CategoryAddViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
