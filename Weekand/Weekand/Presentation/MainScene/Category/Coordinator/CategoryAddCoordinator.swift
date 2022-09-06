//
//  CategoryEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/21.
//

import UIKit

class CategoryAddCoordinator: Coordinator, CategoryEditCoordinatorType {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .categoryAdd
    var categoryAddViewController: CategoryEditViewController<CategoryAddViewModel>
    var categoryUseCase: CategoryUseCase
    
    required init(categoryUseCase: CategoryUseCase) {
        self.categoryAddViewController = CategoryEditViewController<CategoryAddViewModel>()
        self.categoryAddViewController.title = "카테고리 추가"
        self.navigationController = UINavigationController(rootViewController: categoryAddViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.categoryUseCase = categoryUseCase
    }
    
    func start() {
        self.categoryAddViewController.viewModel = CategoryAddViewModel(coordinator: self, categoryUseCase: categoryUseCase)
    }
    
    /// 색상 선택 sheet
    func presentColorBottonSheet() {
        let colorSheetViewController = ColorSheetViewController()
        colorSheetViewController.viewModel = ColorSheetViewModel(coordinator: self)
        colorSheetViewController.selectedColor = categoryAddViewController.selectedColor
        self.navigationController.present(colorSheetViewController, animated: true, completion: nil)
    }
    
    /// 선택된 색상 data를 controller에 전달
    func sendColorFromSheet(color: Color) {
        categoryAddViewController.selectedColor = color
    }
    
    /// Toast message
    func showToastMessage(text: String) {
        categoryAddViewController.showToast(message: text)
    }
    
    /// dismiss
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
    
    /// 완료 후 dismiss
    func endAndDismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
