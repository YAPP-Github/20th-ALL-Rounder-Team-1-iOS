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
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    init(coordinator: CategoryAddCoordinator, categoryUseCase: CategoryUseCase) {
        self.coordinator = coordinator
        self.categoryUseCase = categoryUseCase
    }
    
    struct Input {
        let closeButtonDidTapEvent: Observable<Void>
        let colorButtonDidTapEvent: Observable<Void>
        let categoryNameTextFieldDidEditEvent: Observable<String>
        let confirmButtonDidTapEvent: Observable<Void>
        let selectedOpenType: CategoryOpenType
        let selectedColor: Color
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        input.colorButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushColorBottonSheet()
        }).disposed(by: disposeBag)
        
        input.confirmButtonDidTapEvent
            .withLatestFrom(input.categoryNameTextFieldDidEditEvent)
            .subscribe(onNext: { [weak self] name in
                self?.createCategory(name: name.trimWhiteSpace, color: input.selectedColor.hexCode, openType: input.selectedOpenType)
            }).disposed(by: disposeBag)
        
        return Output()
    }

}

extension CategoryAddViewModel {
    func createCategory(name: String, color: String, openType: CategoryOpenType) {
        self.categoryUseCase.createCategory(name: name, color: color, openType: openType)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    self.coordinator?.dismiss()
                } else {
                    print("error")
                }
            }, onFailure: { error in
                print(error)
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
