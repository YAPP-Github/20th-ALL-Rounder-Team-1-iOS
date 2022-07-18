//
//  MainCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import UIKit

class MainCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .main
    var mainUseCase: MainUseCase
    var mainViewController: MainViewController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainViewController = MainViewController()
        self.mainUseCase = MainUseCase()
    }
    
    func start() {
        self.mainViewController.viewModel = MainViewModel(coordinator: self, mainUseCase: mainUseCase)
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
    func showCategoryScene() {
        let categoryCoordinator = CategoryCoordinator(navigationController: self.navigationController)
        categoryCoordinator.finishDelegate = self
        childCoordinators.append(categoryCoordinator)
        categoryCoordinator.start()
    }
    
    func showEditScene() {
        let scheduleEditCoordinator = ScheduleEditCoordinator()
        scheduleEditCoordinator.finishDelegate = self
        childCoordinators.append(scheduleEditCoordinator)
        navigationController.present(scheduleEditCoordinator.navigationController, animated: true, completion: nil)
        scheduleEditCoordinator.start()
    }
    
    func pushAlarmViewController() {
        let alarmViewController = AlarmViewController()
        alarmViewController.viewModel = AlarmViewModel()
        self.navigationController.pushViewController(alarmViewController, animated: true)
    }
    
    /// 월간 달력으로 날짜 선택 Sheet
    func pushMonthlyCalendarSheet(date: Date) {
        let monthlyCalendarViewController = MonthlyCalendarSheetViewController(currentDate: date)
        monthlyCalendarViewController.viewModel = MonthlyCalendarSheetViewModel(coordinator: self)
        monthlyCalendarViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(monthlyCalendarViewController, animated: true, completion: nil)
    }
    
    /// 받은 스티커 현황 Sheet
    func pushEmojiSheet() {
        let emojiViewController = EmojiSheetViewController()
        emojiViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(emojiViewController, animated: true, completion: nil)
    }
    
    /// 스티커 추가 Sheet
    func pushStickerAddSheet(id: String) {
        // TODO: 이미 선택된 이모지 확인 후 existingEmoji에 넣어준다
        let stickerAddViewController = StickerAddSheetViewController(existingEmoji: .good)
        stickerAddViewController.viewModel = StickerAddSheetViewModel()
        stickerAddViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(stickerAddViewController, animated: true, completion: nil)
    }
    
    // TODO: 검색 화면 구현 후 개발
    func showSearchScene() {
        let userSearchCoordinator = UserSearchCoordinator(navigationController: self.navigationController)
        userSearchCoordinator.finishDelegate = self
        childCoordinators.append(userSearchCoordinator)
        userSearchCoordinator.start()
    }
    
    func sendDateFromMonthlyCalender(date: Date?) {
        
        guard let date = date else { return }
        self.mainViewController.currentDate = date
    }
}

extension MainCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.popToRootViewController(animated: true)
    }
}
