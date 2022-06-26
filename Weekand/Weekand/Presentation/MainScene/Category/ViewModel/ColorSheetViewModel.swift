//
//  ColorBottomSheetViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class ColorSheetViewModel: ViewModelType {
    
    weak var coordinator: CategoryAddCoordinator?
    private var disposeBag = DisposeBag()

    init(coordinator: CategoryAddCoordinator) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let didColorCellSelected: Observable<IndexPath>
        let didTapConfirmButton: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.didTapConfirmButton
            .withLatestFrom(input.didColorCellSelected)
            .subscribe(onNext: { item in
                self.coordinator?.sendColorFromSheet(color: Constants.colors[item.section][item.item])
            }).disposed(by: disposeBag)
        
        return Output()
    }

}
