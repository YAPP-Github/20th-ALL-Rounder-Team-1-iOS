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
        self.navigationController.setNavigationBarHidden(false, animated: true)
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
    
    func showCategoryEditScene() {
        let categoryEditCoordinator = CategoryAddCoordinator()
        categoryEditCoordinator.finishDelegate = self
        childCoordinators.append(categoryEditCoordinator)
        navigationController.present(categoryEditCoordinator.navigationController, animated: true, completion: nil)
        categoryEditCoordinator.start()
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}

extension CategoryCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
