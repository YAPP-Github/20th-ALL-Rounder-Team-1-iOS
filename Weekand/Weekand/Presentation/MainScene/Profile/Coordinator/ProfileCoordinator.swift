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
        let contactCompleteViewController = ContactCompleteViewController()
        self.navigationController.pushViewController(contactCompleteViewController, animated: true)
    }
    
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
    
    func finish() {
        self.navigationController.dismiss(animated: true)
    }
}
