//
//  CategoryEditViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryAddViewModel: CategoryEditViewModelType {
    
    weak var coordinator: CategoryAddCoordinator?
    
    init(coordinator: CategoryAddCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let colorButtonDidTapEvent: Observable<Void>
        let selectedOpenType: BehaviorSubject<String>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        })
        
        input.colorButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushColorBottonSheet()
        })

        input.selectedOpenType.subscribe(onNext: { type in
            print(OpenType.init(rawValue: type))
        })
        
        return Output()
    }

}
