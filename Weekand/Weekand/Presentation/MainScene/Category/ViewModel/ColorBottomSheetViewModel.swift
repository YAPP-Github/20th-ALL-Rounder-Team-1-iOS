//
//  ColorBottomSheetViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class ColorBottomSheetViewModel: ViewModelType {
    
    weak var coordinator: CategoryAddCoordinator?
    
    init(coordinator: CategoryAddCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }

}
