//
//  CoordinatorDidFinishDelegate.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/21.
//

import Foundation

protocol CoordinatorDidFinishDelegate: AnyObject {
    func childDidFinish(_ child: Coordinator)
}
