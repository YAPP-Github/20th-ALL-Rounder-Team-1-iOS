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
        let selectedOpenType: Observable<CategoryOpenType>
        let selectedColor: Observable<Color>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        input.colorButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushColorBottonSheet()
        }).disposed(by: disposeBag)
        
        let categoryInput = Observable.combineLatest(input.categoryNameTextFieldDidEditEvent, input.selectedColor, input.selectedOpenType)
        
        input.confirmButtonDidTapEvent
            .withLatestFrom(categoryInput)
            .subscribe(onNext: { [weak self] name, color, openType in
                self?.createCategory(name: name, color: color.hexCode, openType: openType)
            }).disposed(by: disposeBag)
        
        return Output()
    }

}

extension CategoryAddViewModel {
    func createCategory(name: String, color: String, openType: CategoryOpenType) {
        self.categoryUseCase.createCategory(name: name, color: color, openType: openType)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    self.coordinator?.endAndDismiss()
                } else {
                    self.coordinator?.showToastMessage(text: "일정 추가에 실패하였습니다.")
                }
            }, onFailure: { error in
                if error.localizedDescription == CategoryError.duplicatedName.serverDescription {
                    self.coordinator?.showToastMessage(text: error.localizedDescription)
                } else {
                    self.coordinator?.showToastMessage(text: "일정 추가에 실패하였습니다.")
                }
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
