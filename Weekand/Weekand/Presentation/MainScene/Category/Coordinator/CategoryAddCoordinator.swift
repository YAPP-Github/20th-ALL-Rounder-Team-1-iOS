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
    
    func pushColorBottonSheet() {
        let colorSheetViewController = ColorSheetViewController()
        colorSheetViewController.viewModel = ColorSheetViewModel(coordinator: self)
        colorSheetViewController.selectedColor = categoryAddViewController.selectedColor
        self.navigationController.present(colorSheetViewController, animated: true, completion: nil)
    }
    
    func sendColorFromSheet(color: Color) {
        categoryAddViewController.selectedColor = color
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
    
    func endAndDismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
