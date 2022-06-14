//
//  CategoryListCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import UIKit

class CategoryCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .category
    var categoryListViewController: CategoryListViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.categoryListViewController = CategoryListViewController()
    }
    
    func start() {
        self.categoryListViewController.viewModel = CategoryListViewModel(coordinator: self)
        self.navigationController.pushViewController(categoryListViewController, animated: true)
    }
    
    func pushCategoryDetailViewController() {
        let categoryDetailViewController = CategoryDetailViewController()
        categoryDetailViewController.viewModel = CategoryDetailViewModel(coordinator: self)
        self.navigationController.pushViewController(categoryDetailViewController, animated: true)
    }
    
    func pushCategoryEditViewController() {
        let categoryEditViewController = CategoryEditViewController()
        categoryEditViewController.viewModel = CategoryEditViewModel(coordinator: self)
        self.navigationController.pushViewController(categoryEditViewController, animated: true)    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
