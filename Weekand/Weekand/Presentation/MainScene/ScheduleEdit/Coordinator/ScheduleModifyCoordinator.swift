//
//  ScheduleModifyCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import UIKit

class ScheduleModifyCoordinator: ScheduleEditCoordinatorType {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleEditViewController: ScheduleEditViewController<ScheduleModifyViewModel>
    var type: CoordinatorType = .scheduleModify
    var scheduleEditUseCase: ScheduleEditUseCase
    var scheduleId: String
    var requestDate: Date
    
    required init(scheduleId: String, requestDate: Date) {
        self.scheduleEditViewController = ScheduleEditViewController(requestDate: requestDate)
        self.navigationController = UINavigationController(rootViewController: scheduleEditViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.scheduleEditViewController.navigationItem.title = "일정 수정"
        self.scheduleEditUseCase = ScheduleEditUseCase()
        self.scheduleId = scheduleId
        self.requestDate = requestDate
    }
    
    func start() {
        let scheduleModifyViewModel = ScheduleModifyViewModel(coordinator: self,
                                                              scheduleEditUseCase: scheduleEditUseCase,
                                                              scheduleId: self.scheduleId)
        scheduleModifyViewModel.getSchedule()
        self.scheduleEditViewController.viewModel = scheduleModifyViewModel
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
    
    /// 선택된 카테고리 data를 controller에 전달
    func presentCategorySheet() {
        let categoryListSheetViewController = CategoryListSheetViewController()
        let categoryListSheetViewModel = CategoryListSheetViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase)
        categoryListSheetViewController.viewModel = categoryListSheetViewModel
        categoryListSheetViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(categoryListSheetViewController, animated: true, completion: nil)
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
