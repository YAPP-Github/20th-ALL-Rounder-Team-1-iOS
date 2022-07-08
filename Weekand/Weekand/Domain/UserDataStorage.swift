//
//  UserDataStorage.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/04.
//

import Foundation

final class UserDataStorage {
    
    static let shared = UserDataStorage()
    
    var userID: String?
    var accessToken: String?
    
    init() {
        
    }
}

extension UserDataStorage {
    
    func setUserID(id: String) {
        UserDataStorage.shared.userID = id
    }
    
    func setAccessToken(token: String) {
        UserDataStorage.shared.accessToken = token
    }
}
