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
    var selectedCategory: Category
    
    required init(categoryUseCase: CategoryUseCase, selectedCategory: Category) {
        self.categoryUseCase = categoryUseCase
        self.categoryModifyViewController = CategoryEditViewController<CategoryModifyViewModel>()
        self.categoryModifyViewController.title = "카테고리 수정"
        self.navigationController = UINavigationController(rootViewController: categoryModifyViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.selectedCategory = selectedCategory
    }
    
    func start() {
        self.categoryModifyViewController.viewModel = CategoryModifyViewModel(coordinator: self,
                                                                              categoryUseCase: categoryUseCase,
                                                                              category: self.selectedCategory)
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
    
    func showToastMessage(text: String) {
        categoryModifyViewController.showToast(message: text)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
    
    func endAndDismiss(categoryName: String) {
        self.navigationController.dismiss(animated: true)
    }
    
}
