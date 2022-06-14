//
//  CategoryEditViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation

class CategoryEditViewModel {
    
    weak var coordinator: CategoryCoordinator?
    
    init(coordinator: CategoryCoordinator) {
        
        self.coordinator = coordinator
    }

}
