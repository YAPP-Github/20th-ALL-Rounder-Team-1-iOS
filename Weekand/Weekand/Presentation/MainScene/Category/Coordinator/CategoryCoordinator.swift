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
        self.categoryListViewController.title = "카테고리"
        self.categoryUseCase = CategoryUseCase()
    }
    
    func start() {
        self.categoryListViewController.viewModel = CategoryListViewModel(coordinator: self, categoryUseCase: categoryUseCase)
        self.navigationController.pushViewController(categoryListViewController, animated: true)
    }
    
    /// 카테고리 상세 화면
    func pushCategoryDetailViewController(category: Category) {
        let categoryDetailViewController = CategoryDetailViewController()
        categoryDetailViewController.selectedCategory = category
        categoryDetailViewController.viewModel = CategoryDetailViewModel(coordinator: self, categoryUseCase: categoryUseCase)
        self.navigationController.pushViewController(categoryDetailViewController, animated: true)
    }
    
    /// 카테고리 추가 화면
    func showCategoryAddScene() {
        let categoryAddCoordinator = CategoryAddCoordinator(categoryUseCase: categoryUseCase)
        categoryAddCoordinator.finishDelegate = self
        childCoordinators.append(categoryAddCoordinator)
        navigationController.present(categoryAddCoordinator.navigationController, animated: true, completion: nil)
        categoryAddCoordinator.start()
    }
    
    /// 카테고리 수정 화면
    func showCategoryModifyScene(category: Category) {
        let categoryModifyCoordinator = CategoryModifyCoordinator(categoryUseCase: categoryUseCase, selectedCategory: category)
        categoryModifyCoordinator.finishDelegate = self
        childCoordinators.append(categoryModifyCoordinator)
        navigationController.present(categoryModifyCoordinator.navigationController, animated: true, completion: nil)
        categoryModifyCoordinator.start()
    }
    
    /// 일정 추가 화면
    func showScheduleAddScene(category: Category) {
        let scheduleAddCoordinator = ScheduleAddCoordinator(requestDate: Date())
        scheduleAddCoordinator.finishDelegate = self
        childCoordinators.append(scheduleAddCoordinator)
        navigationController.present(scheduleAddCoordinator.navigationController, animated: true, completion: nil)
        scheduleAddCoordinator.start()
        scheduleAddCoordinator.sendCategoryFromCategoryScene(category: category)
    }
    
    /// 일정 수정 화면
    func showScheduleModifyScene(schedule: ScheduleSummary) {
        let scheduleModifyCoordinator = ScheduleModifyCoordinator(scheduleId: schedule.scheduleId, requestDate: schedule.dateStart)
        scheduleModifyCoordinator.finishDelegate = self
        childCoordinators.append(scheduleModifyCoordinator)
        navigationController.present(scheduleModifyCoordinator.navigationController, animated: true, completion: nil)
        scheduleModifyCoordinator.start()
    }
    
    /// 일정 상세 화면
    func showScheduleDetailScene(schedule: ScheduleSummary) {
        let scheduleDetailCoordinator = ScheduleDetailCoordinator(
            navigationController: self.navigationController,
            scheduleId: schedule.scheduleId,
            isStatusEditing: false,
            requestDate: schedule.dateStart)
        scheduleDetailCoordinator.finishDelegate = self
        childCoordinators.append(scheduleDetailCoordinator)
        scheduleDetailCoordinator.start()
    }
    
    /// Toast message
    func showToastMessage(text: String) {
        categoryListViewController.showToast(message: text)
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
