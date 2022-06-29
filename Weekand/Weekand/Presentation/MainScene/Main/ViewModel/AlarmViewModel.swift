//
//  AlarmViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/29.
//

import UIKit
import RxSwift

class AlarmViewModel {
    
    weak var coordinator: AlarmCoordinator?
    let dispoaseBag = DisposeBag()
    
    init(coordinator: AlarmCoordinator) {
        self.coordinator = coordinator
    }

}
