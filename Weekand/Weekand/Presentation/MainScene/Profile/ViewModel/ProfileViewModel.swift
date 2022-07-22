//
//  ProfileViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import RxSwift

class ProfileViewModel {
    
    weak var coordinator: ProfileCoordinator?
    private let disposeBag = DisposeBag()
    
    var userId: String?
    var isMyPage: Bool {
        
        guard let id = userId else {
            return false
        }
        
        return UserDataStorage.shared.userID == id ? true : false
    }
    
    init (coordinator: ProfileCoordinator, userId: String?) {
        self.coordinator = coordinator
        self.userId = userId
    }
    
}
