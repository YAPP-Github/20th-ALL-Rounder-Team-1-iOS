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
    
    weak var coordinator: CategoryEditCoordinatorType?
    private var disposeBag = DisposeBag()

    init(coordinator: CategoryEditCoordinatorType) {
        
        self.coordinator = coordinator
    }
    
    struct Input {
        let didColorCellSelected: Observable<IndexPath>
        let didTapConfirmButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didTapConfirmButton
            .withLatestFrom(input.didColorCellSelected)
            .subscribe(onNext: { item in
                if let coordinator = self.coordinator as? CategoryAddCoordinator {
                    coordinator.sendColorFromSheet(color: Constants.colors[item.section][item.item])
                } else if let coordinator = self.coordinator as? CategoryModifyCoordinator {
                    coordinator.sendColorFromSheet(color: Constants.colors[item.section][item.item])
                }
                
            }).disposed(by: disposeBag)
        
        return Output()
    }

}
