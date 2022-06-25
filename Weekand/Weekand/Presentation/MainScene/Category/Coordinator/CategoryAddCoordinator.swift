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
    
    required init() {
        self.categoryAddViewController = CategoryEditViewController<CategoryAddViewModel>()
        self.categoryAddViewController.title = "카테고리 추가"
        self.navigationController = UINavigationController(rootViewController: categoryAddViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
    }
    
    func start() {
        self.categoryAddViewController.viewModel = CategoryAddViewModel(coordinator: self)
    }
    
    func pushColorBottonSheet() {
        let colorBottomSheetViewController = BottomSheetViewController<ColorBottomSheetViewModel>()
        colorBottomSheetViewController.viewModel = ColorBottomSheetViewModel(coordinator: self)
        self.navigationController.present(colorBottomSheetViewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}
