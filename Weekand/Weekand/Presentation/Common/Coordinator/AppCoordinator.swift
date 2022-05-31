//
//  AppCoordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: self.navigationController)
        welcomeCoordinator.start()
        childCoordinators.append(welcomeCoordinator)
    }
}
