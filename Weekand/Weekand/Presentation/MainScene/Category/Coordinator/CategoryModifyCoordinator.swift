//
//  CategoryModifyCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/22.
//

import UIKit

class CategoryModifyCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .category
    var categoryModifyViewController: CategoryEditViewController
    
    required init() {
        self.categoryModifyViewController = CategoryEditViewController()
        self.categoryModifyViewController.title = "카테고리 추가"
        self.navigationController = UINavigationController(rootViewController: categoryModifyViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.categoryModifyViewController.viewModel = CategoryModifyViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
