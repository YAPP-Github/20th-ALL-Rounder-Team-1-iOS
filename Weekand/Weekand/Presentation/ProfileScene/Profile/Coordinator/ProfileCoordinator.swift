//
//  ProfileCoordinator.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var profileViewController: ProfileViewController
    var profileEditViewController: ProfileEditViewController
    var profileUseCase: ProfileUseCase
    var type: CoordinatorType = .profile
    var userId: String?
    
    
    required init(navigationController: UINavigationController, userId: String?) {
        
        self.navigationController = navigationController
        self.profileViewController = ProfileViewController()
        self.profileEditViewController = ProfileEditViewController()
        self.profileUseCase = ProfileUseCase()
        self.userId = userId
        
    }
    
    func start() {
        self.profileViewController.viewModel = ProfileViewModel(coordinator: self, useCase: profileUseCase, userId: userId)
        self.navigationController.pushViewController(profileViewController, animated: true)
    }
    
    /// 프로필 설정으로 이동
    func pushProfileEditViewController() {
        
        profileEditViewController.viewModel = ProfileEditViewModel(coordinator: self, useCase: profileUseCase)
        self.navigationController.pushViewController(profileEditViewController, animated: true)
    }
    
    /// 문의하기로 이동
    func pushContactViewController() {
        let contactViewController = ContactViewController()
        contactViewController.viewModel = ContactViewModel(coordinator: self, useCase: profileUseCase)
        self.navigationController.pushViewController(contactViewController, animated: true)
    }
    
    /// 문의완료로 이동
    func pushContactCompleteViewController() {
        self.navigationController.popViewController(animated: false)
        let contactCompleteViewController = ContactCompleteViewController()
        self.navigationController.pushViewController(contactCompleteViewController, animated: true)
    }
    
    /// 문의 완료 닫기
    func finishContact() {
        self.navigationController.popViewController(animated: true)
        self.navigationController.popViewController(animated: false)
    }
    
    func pushPasswordChangeViewController() {
        let passwordChangeViewController = PasswordChangeViewController()
        passwordChangeViewController.viewModel = PasswordChangeViewModel(coordinator: self, useCase: profileUseCase)
        self.navigationController.pushViewController(passwordChangeViewController, animated: true)
    }
    
    func presentWarningPopViewController() {
        let warningPopupCoordinator = ResignWarningPopupCoordinator(useCase: profileUseCase)
        childCoordinators.append(warningPopupCoordinator)
        navigationController.present(warningPopupCoordinator.navigationController, animated: true, completion: nil)
        warningPopupCoordinator.start()
    }
    
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
    
    
    // MARK: Bottom Sheet
    
    /// 프로필설정 - 직업선택 Sheet
    func presentJobInformationSheet() {
        let jobSelectionSheetController = SelectionSheetViewController(informationType: .job)
        jobSelectionSheetController.viewModel = SelectionSheetViewModel(coordinator: self, informationType: .job)
        jobSelectionSheetController.modalPresentationStyle = .overFullScreen
        jobSelectionSheetController.informations = profileEditViewController.selectedJobs
        self.navigationController.present(jobSelectionSheetController, animated: true, completion: nil)
    }
    
    /// 프로필설정 - 관심사선택 Sheet
    func presentInterestsInformationSheet() {
        let interestSelectionSheetController = SelectionSheetViewController(informationType: .interests)
        interestSelectionSheetController.viewModel = SelectionSheetViewModel(coordinator: self, informationType: .interests)
        interestSelectionSheetController.modalPresentationStyle = .overFullScreen
        interestSelectionSheetController.informations = profileEditViewController.selectedInterests
        self.navigationController.present(interestSelectionSheetController, animated: true, completion: nil)
    }
    
    func setJobInformations(_ selectedJobs: [String]) {
        profileEditViewController.selectedJobs = selectedJobs
    }
    
    func setInterestsInformations(_ selectedInterests: [String]) {
        profileEditViewController.selectedInterests = selectedInterests
    }
    
    func showToastMessage(text: String) {
        profileEditViewController.showToast(message: text)
    }
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}

extension ProfileCoordinator: CoordinatorDidFinishDelegate {
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
