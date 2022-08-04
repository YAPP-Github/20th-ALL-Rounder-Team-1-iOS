//
//  ScheduleEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import Foundation
import UIKit

class ScheduleAddCoordinator: Coordinator, ScheduleEditCoordinatorType {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleEditViewController: ScheduleEditViewController<ScheduleAddViewModel>
    var type: CoordinatorType = .scheduleAdd
    var scheduleEditUseCase: ScheduleEditUseCase
    
    required init(requestDate: Date) {
        self.scheduleEditViewController = ScheduleEditViewController(requestDate: requestDate)
        self.navigationController = UINavigationController(rootViewController: scheduleEditViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.scheduleEditViewController.navigationItem.title = "일정 추가"
        self.scheduleEditUseCase = ScheduleEditUseCase()
    }
    
    func start() {
        let scheduleAddViewModel = ScheduleAddViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase)
        scheduleAddViewModel.searchCategories()
        self.scheduleEditViewController.viewModel = scheduleAddViewModel
    }
    
    /// 반복 선택 sheet
    func presentRepeatSheet() {
        let repeatSheetViewController = RepeatSheetViewController()
        
        let dayViewController = DefaultRepeatViewController()
        let weekRepeatViewController = WeekRepeatViewController()
        let monthRepeatViewController = DefaultRepeatViewController()
        let yearRepeatViewController = DefaultRepeatViewController()
        
        repeatSheetViewController.viewController.viewControllers.append(dayViewController)
        repeatSheetViewController.viewController.viewControllers.append(weekRepeatViewController)
        repeatSheetViewController.viewController.viewControllers.append(monthRepeatViewController)
        repeatSheetViewController.viewController.viewControllers.append(yearRepeatViewController)
        
        dayViewController.viewModel = DefaultRepeatViewModel(coordinator: self, repeatType: .daily)
        weekRepeatViewController.viewModel = WeekRepeatViewModel(coordinator: self)
        monthRepeatViewController.viewModel = DefaultRepeatViewModel(coordinator: self, repeatType: .monthly)
        yearRepeatViewController.viewModel = DefaultRepeatViewModel(coordinator: self, repeatType: .yearly)
        
        repeatSheetViewController.modalPresentationStyle = .pageSheet
        self.navigationController.present(repeatSheetViewController, animated: true, completion: nil)
    }
    
    /// 카테고리 선택 sheet
    func presentCategorySheet() {
        let categoryListSheetViewController = CategoryListSheetViewController()
        let categoryListSheetViewModel = CategoryListSheetViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase)
        categoryListSheetViewController.viewModel = categoryListSheetViewModel
        categoryListSheetViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(categoryListSheetViewController, animated: true, completion: nil)
    }
    
    /// 선택된 카테고리 data를 controller에 전달
    func sendCategoryFromCategoryScene(category: Category) {
        scheduleEditViewController.category = category
    }
    
    /// 선택된 카테고리 data를 controller에 전달
    func sendCategoryFromSheet(category: Category) {
        scheduleEditViewController.category = category
    }
    
    /// 선택된 반복 data를 controller에 전달
    func sendRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?) {
        scheduleEditViewController.repeatType = repeatType
        scheduleEditViewController.repeatEnd = repeatEndDate
    }
    
    /// 선택된 반복 data를 controller에 전달
    func sendWeekRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?, repeatSelectedValue: [ScheduleWeek]) {
        scheduleEditViewController.repeatType = repeatType
        scheduleEditViewController.repeatSelectedValue = repeatSelectedValue
        scheduleEditViewController.repeatEnd = repeatEndDate
    }
    
    /// 경고 Popup
    func presentAlertPopupViewController(titleText: String,
                                         informText: String,
                                         confirmButtonText: String,
                                         cancelButtonText: String,
                                         completionHandler: @escaping () -> Void) {
        let alertPopupCoordinator = AlertPopupCoordinator(titleText: titleText,
                                                            informText: informText,
                                                            confirmButtonText: confirmButtonText,
                                                            cancelButtonText: cancelButtonText,
                                                            completionHandler: completionHandler)
        childCoordinators.append(alertPopupCoordinator)
        navigationController.present(alertPopupCoordinator.navigationController, animated: true, completion: nil)
        alertPopupCoordinator.start()
    }
    
    /// Toast message
    func showToastMessage(text: String) {
        scheduleEditViewController.showToast(message: text)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}
