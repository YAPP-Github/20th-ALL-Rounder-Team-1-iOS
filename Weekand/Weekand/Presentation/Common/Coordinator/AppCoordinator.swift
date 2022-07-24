//
//  AppCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType = .app
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if UserDefaults.standard.bool(forKey: "autoSign") {
//            showMainScene()
            showWelcomeScene()
        } else {
            showWelcomeScene()
        }
    }
    
    private func showWelcomeScene() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: self.navigationController)
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showMainScene() {
        let mainCoordinator = MainCoordinator(navigationController: self.navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
