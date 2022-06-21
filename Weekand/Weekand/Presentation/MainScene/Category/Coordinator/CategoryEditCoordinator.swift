//
//  CategoryEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/21.
//

import UIKit

class CategoryEidtCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .category
    var categoryEditViewController: CategoryEditViewController
    
    required init() {
        self.categoryEditViewController = CategoryEditViewController()
        self.categoryEditViewController.title = "카테고리 추가"
        self.navigationController = UINavigationController(rootViewController: categoryEditViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.categoryEditViewController.viewModel = CategoryEditViewModel(coordinator: self)
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
