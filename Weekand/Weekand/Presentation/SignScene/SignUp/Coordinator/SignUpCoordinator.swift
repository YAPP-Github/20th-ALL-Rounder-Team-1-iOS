//
//  SignUpCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class SignUpCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var signUpViewController: SignUpViewController
    var signUpUseCase: SignUpUseCase
    var type: CoordinatorType = .signUp
    
    required init() {
        self.signUpViewController = SignUpViewController()
        self.signUpUseCase = SignUpUseCase()
        self.navigationController = UINavigationController(rootViewController: signUpViewController)
        self.navigationController.modalPresentationStyle = .overFullScreen
    }
    
    func start() {
        let signUpModel = SignUpModel()
        self.signUpViewController.viewModel = SignUpViewModel(
                                                coordinator: self,
                                                signUpUseCase: signUpUseCase,
                                                signUpModel: signUpModel)
    }
    
    func pushAddInformationViewController(signUpModel: SignUpModel) {
        let signUpAddInformationViewController = SignUpAddInfomationViewController()
        signUpAddInformationViewController.viewModel = SignUpAddInfomationViewModel(coordinator: self, signUpModel: signUpModel)
        self.navigationController.pushViewController(signUpAddInformationViewController, animated: true)
    }
    
    func pushTermsViewController(signUpModel: SignUpModel) {
        let signUpTermsViewController  = SignUpTermsViewController()
        signUpTermsViewController.viewModel = SignUpTermsViewModel(
                                                    coordinator: self,
                                                    signUpUseCase: signUpUseCase,
                                                    signUpModel: signUpModel)
        self.navigationController.pushViewController(signUpTermsViewController, animated: true)
    }
    
    func presentPopViewController(titleText: String, informText: String, dismissParentCoordinator: Bool) {
        let authPopupCoordinator = SimplePopupCoordinator(
                                        titleText: titleText,
                                        informText: informText,
                                        dismissParentCoordinator: dismissParentCoordinator)
        childCoordinators.append(authPopupCoordinator)
        navigationController.present(authPopupCoordinator.navigationController, animated: true, completion: nil)
        authPopupCoordinator.finishDelegate = self
        authPopupCoordinator.start()
    }
    
    func showToastMessage() {
        signUpViewController.showToast(message: "닉네임은 2글자 이상 12글자 이하만 가능합니다.")
    }
    
    func finish() {
        self.finishDelegate?.childDidFinish(self)
    }
}

extension SignUpCoordinator: CoordinatorDidFinishDelegate {
    func childDidFinish(_ child: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != child.type })
        navigationController.dismiss(animated: true, completion: nil)
    }
}
