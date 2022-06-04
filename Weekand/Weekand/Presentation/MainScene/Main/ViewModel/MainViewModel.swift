//
//  MainViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/04.
//

import Foundation

class MainViewModel {
    
    weak var coordinator: MainCoordinator?
    
    init(coordinator: MainCoordinator) {
        
        self.coordinator = coordinator
    }
    
}
