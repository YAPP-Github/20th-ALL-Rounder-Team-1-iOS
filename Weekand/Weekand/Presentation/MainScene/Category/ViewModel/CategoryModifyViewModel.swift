//
//  CategoryModifyViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryModifyViewModel: CategoryEditViewModelType {
    
    weak var coordinator: CategoryModifyCoordinator?
    private let categoryUseCase: CategoryUseCase
    private var disposeBag = DisposeBag()
    
    init(coordinator: CategoryModifyCoordinator, categoryUseCase: CategoryUseCase) {
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
        let selectedCategory: Category?
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
                guard let category = input.selectedCategory else {
                    return
                }
                self?.updateCategory(id: category.serverID, name: name, color: color.hexCode, openType: openType)
            }).disposed(by: disposeBag)
        
        return Output()
    }

}

extension CategoryModifyViewModel {
    func updateCategory(id: String, name: String, color: String, openType: CategoryOpenType) {
        let categoryInput = ScheduleCategoryInput(name: name, color: color, openType: openType.toModel())
        self.categoryUseCase.updateCategory(id: id, scheduleCategoryInput: categoryInput)
            .subscribe(onSuccess: { categoryName in
                if categoryName != "" {
                    self.coordinator?.endAndDismiss(categoryName: categoryName)
                } else {
                    self.coordinator?.showToastMessage(text: "일정 수정에 실패하였습니다.")
                }
            }, onFailure: { error in
                if error.localizedDescription == CategoryError.duplicatedName.serverDescription {
                    self.coordinator?.showToastMessage(text: error.localizedDescription)
                } else {
                    self.coordinator?.showToastMessage(text: "일정 수정에 실패하였습니다.")
                }
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
