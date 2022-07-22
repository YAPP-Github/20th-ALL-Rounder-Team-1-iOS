//
//  ScheduleEditCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import Foundation
import UIKit

class ScheduleEditCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var scheduleEditViewController: ScheduleEditViewController
    var type: CoordinatorType = .scheduleEdit
    var scheduleEditUseCase: ScheduleEditUseCase
    
    required init() {
        self.scheduleEditViewController = ScheduleEditViewController()
        self.navigationController = UINavigationController(rootViewController: scheduleEditViewController)
        self.navigationController.modalPresentationStyle = .fullScreen
        self.scheduleEditUseCase = ScheduleEditUseCase()
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
        self.scheduleEditViewController.viewModel = ScheduleEditViewModel(coordinator: self, scheduleEditUseCase: scheduleEditUseCase, scheduleInputModel: scheduleInputModel)
        
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
        scheduleEditViewController.category = category
    }
    
    func sendRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?) {
        scheduleEditViewController.repeatType = repeatType
        scheduleEditViewController.repeatEnd = repeatEndDate
    }
    
    func sendWeekRepeatTypeFromSheet(repeatType: ScheduleRepeatType, repeatEndDate: Date?, repeatSelectedValue: [ScheduleWeek]) {
        scheduleEditViewController.repeatType = repeatType
        scheduleEditViewController.repeatSelectedValue = repeatSelectedValue
        scheduleEditViewController.repeatEnd = repeatEndDate
    }
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
