//
//  Coordinator.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/31.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
