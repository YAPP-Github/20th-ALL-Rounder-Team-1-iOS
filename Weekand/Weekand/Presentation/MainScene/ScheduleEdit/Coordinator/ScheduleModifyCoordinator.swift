//
//  ScheduleModifyCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import UIKit

class ScheduleModifyCoordinator: ScheduleCoordinatorType {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleModifyViewController: ScheduleModifyViewController
    var type: CoordinatorType = .scheduleModify
    var scheduleEditUseCase: ScheduleEditUseCase
    var scheduleId: String
    
    required init(selectedScheduleId: String) {
        self.scheduleModifyViewController = ScheduleModifyViewController()
        self.navigationController = UINavigationController(rootViewController: scheduleModifyViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.scheduleEditUseCase = ScheduleEditUseCase()
        self.scheduleId = selectedScheduleId
    }
    
    func start() {
        let scheduleInputModel = ScheduleInputModel(
                                        name: "",
                                        categoryId: "",
                                        dateStart: Date(),
                                        dateEnd: Date(),
                                        repeatType: .once,
                                        repeatSelectedValue: nil,
                                        repeatEnd: nil,
                                        memo: nil)
        self.scheduleModifyViewController.viewModel = ScheduleModifyViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase, scheduleInputModel: scheduleInputModel)
        self.scheduleModifyViewController.setSchedule(scheduleId: scheduleId)
    }
    
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
    
    func presentCategorySheet() {
        let categoryListSheetViewController = CategoryListSheetViewController()
        let categoryListSheetViewModel = CategoryListSheetViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase)
        categoryListSheetViewController.viewModel = categoryListSheetViewModel
        categoryListSheetViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(categoryListSheetViewController, animated: true, completion: nil)
    }
    
    func sendCategoryFromSheet(category: Category) {
        scheduleModifyViewController.category = category
    }
    
    func sendRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?) {
        scheduleModifyViewController.repeatType = repeatType
        scheduleModifyViewController.repeatEnd = repeatEndDate
    }
    
    func sendWeekRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?, repeatSelectedValue: [ScheduleWeek]) {
        scheduleModifyViewController.repeatType = repeatType
        scheduleModifyViewController.repeatSelectedValue = repeatSelectedValue
        scheduleModifyViewController.repeatEnd = repeatEndDate
    }
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
