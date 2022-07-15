//
//  CategoryModifyCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/22.
//

import UIKit

class CategoryModifyCoordinator: Coordinator, CategoryEditCoordinatorType {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .categoryModify
    var categoryModifyViewController: CategoryEditViewController<CategoryModifyViewModel>
    var categoryUseCase: CategoryUseCase
    
    required init(categoryUseCase: CategoryUseCase, selectedCategory: Category) {
        self.categoryUseCase = categoryUseCase
        self.categoryModifyViewController = CategoryEditViewController<CategoryModifyViewModel>()
        self.categoryModifyViewController.title = "카테고리 추가"
        self.categoryModifyViewController.selectedCategory = selectedCategory
        self.navigationController = UINavigationController(rootViewController: categoryModifyViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.categoryModifyViewController.viewModel = CategoryModifyViewModel(coordinator: self, categoryUseCase: categoryUseCase)
    }
    
    func pushColorBottonSheet() {
        let colorSheetViewController = ColorSheetViewController()
        colorSheetViewController.viewModel = ColorSheetViewModel(coordinator: self)
        colorSheetViewController.selectedColor = categoryModifyViewController.selectedColor
        self.navigationController.present(colorSheetViewController, animated: true, completion: nil)
    }
    
    func sendColorFromSheet(color: Color) {
        categoryModifyViewController.selectedColor = color
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
