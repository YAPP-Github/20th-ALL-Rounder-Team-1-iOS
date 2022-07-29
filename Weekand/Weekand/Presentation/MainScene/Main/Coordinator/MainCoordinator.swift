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
        let scheduleAddCoordinator = ScheduleAddCoordinator()
        scheduleAddCoordinator.finishDelegate = self
        childCoordinators.append(scheduleAddCoordinator)
        navigationController.present(scheduleAddCoordinator.navigationController, animated: true, completion: nil)
        scheduleAddCoordinator.start()
    }
    
    func showProfileScene(id: String?) {
        let profileCoordinator = ProfileCoordinator(navigationController: self.navigationController, userId: id)
        profileCoordinator.finishDelegate = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    /// 알람 화면
    func pushAlarmViewController() {
        let alarmViewController = AlarmViewController()
        alarmViewController.viewModel = AlarmViewModel(mainUseCase: mainUseCase)
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
    func pushEmojiSheet(id: String, date: Date) {
        // TODO: id, date값 넘겨줘서 서버 통신
        let emojiViewController = EmojiSheetViewController(id: id, date: date)
        emojiViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(emojiViewController, animated: true, completion: nil)
    }
    
    /// 스티커 추가 Sheet
    func pushStickerAddSheet(id: String, date: Date) {
        // TODO: 이미 선택된 이모지 확인 후 existingEmoji에 넣어준다
        let stickerAddViewController = StickerAddSheetViewController()
        stickerAddViewController.viewModel = StickerAddSheetViewModel(mainUseCase: mainUseCase, id: id, date: date)
        stickerAddViewController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(stickerAddViewController, animated: true, completion: nil)
    }
    
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
        if UserDefaults.standard.bool(forKey: "autoSign") {
            NotificationCenter.default.post(name: NSNotification.Name("showWeclomeScene"), object: nil, userInfo: nil)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
