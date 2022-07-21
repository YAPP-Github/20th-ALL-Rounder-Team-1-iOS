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
    
    init (coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
}
