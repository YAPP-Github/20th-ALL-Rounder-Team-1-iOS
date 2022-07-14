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
    var categoryUseCase: CategoryUseCase
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.categoryListViewController = CategoryListViewController()
        self.categoryUseCase = CategoryUseCase()
    }
    
    func start() {
        self.categoryListViewController.viewModel = CategoryListViewModel(coordinator: self, categoryUseCase: categoryUseCase)
        self.navigationController.pushViewController(categoryListViewController, animated: true)
    }
    
    func pushCategoryDetailViewController() {
        let categoryDetailViewController = CategoryDetailViewController()
        categoryDetailViewController.viewModel = CategoryDetailViewModel(coordinator: self, categoryUseCase: categoryUseCase)
        self.navigationController.pushViewController(categoryDetailViewController, animated: true)
    }
    
    func showCategoryAddScene() {
        let categoryAddCoordinator = CategoryAddCoordinator(categoryUseCase: categoryUseCase)
        categoryAddCoordinator.finishDelegate = self
        childCoordinators.append(categoryAddCoordinator)
        navigationController.present(categoryAddCoordinator.navigationController, animated: true, completion: nil)
        categoryAddCoordinator.start()
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}

extension CategoryCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        if child.type == .categoryAdd {
            self.categoryListViewController.setCategoryList()
        }
        navigationController.dismiss(animated: true, completion: nil)
    }
}
