//
//  UserSearchCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import UIKit

class UserSearchCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .userSearch
    var userSearchViewController: UserSearchViewController
    var searchUseCase: SearchUseCase
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.userSearchViewController = UserSearchViewController()
        self.searchUseCase = SearchUseCase()
    }
    
    func start() {
        self.userSearchViewController.viewModel = UserSearchViewModel(coordinator: self, searchUseCase: searchUseCase)
        self.navigationController.pushViewController(userSearchViewController, animated: true)
    }
    
    func presentJobInformationSheet() {
        let jobInformationSheetController = InformationSheetController(informationType: .job)
        jobInformationSheetController.viewModel = InformationSheetViewModel(coordinator: self, informationType: .job)
        jobInformationSheetController.modalPresentationStyle = .overFullScreen
        jobInformationSheetController.informations = userSearchViewController.selectedJobs
        self.navigationController.present(jobInformationSheetController, animated: true, completion: nil)
    }
    
    func presentInterestsInformationSheet() {
        let interestsInformationSheetController = InformationSheetController(informationType: .interests)
        interestsInformationSheetController.viewModel = InformationSheetViewModel(coordinator: self, informationType: .interests)
        interestsInformationSheetController.modalPresentationStyle = .overFullScreen
        interestsInformationSheetController.informations = userSearchViewController.selectedInterests
        self.navigationController.present(interestsInformationSheetController, animated: true, completion: nil)
    }
    
    func setJobInformations(_ selectedJobs: [String]) {
        userSearchViewController.selectedJobs = selectedJobs
    }
    
    func setInterestsInformations(_ selectedInterests: [String]) {
        userSearchViewController.selectedInterests = selectedInterests
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
    
}

extension UserSearchCoordinator: CoordinatorDidFinishDelegate {
    
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
