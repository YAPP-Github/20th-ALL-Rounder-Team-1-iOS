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
            .withLatestFrom(input.categoryNameTextFieldDidEditEvent.map(trimmigText))
            .subscribe(onNext: { [weak self] text in
                // server
                print(text)
                print(input.selectedOpenType)
                print(input.selectedColor)
                self?.coordinator?.dismiss()
            }).disposed(by: disposeBag)
        
        return Output()
    }
    
    private func trimmigText(text: String) -> String {
        return text.trimmingCharacters(in: [" "])
    }

}
