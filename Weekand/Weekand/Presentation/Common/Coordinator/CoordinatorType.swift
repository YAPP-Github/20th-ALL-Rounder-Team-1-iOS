//
//  CoordinatorType.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/03.
//

import Foundation

enum CoordinatorType {
    // Common
    case app
    case simplePopup
    
    // Sign Scene
    case welcome
    case signIn
    case signUp
    case passwordFind
    
    // Main Scene
    case main
    case category
    case categoryAdd
    case categoryModify
    case scheduleEdit
    case userSearch
    case profile
}
