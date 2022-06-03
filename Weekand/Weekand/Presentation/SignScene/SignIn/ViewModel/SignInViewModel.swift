//
//  SignInViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
    weak var coordinator: SignInCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignInCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let emailTextFieldDidEditEvent: Observable<String>
        let passwordTextFieldDidEditEvent: Observable<String>
        let autoSignButtonDidTapEvent: Observable<Void>
        // let passwordFindButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var nextButtonEnable: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonEnable = Observable
                                    .combineLatest(
                                        input.emailTextFieldDidEditEvent,
                                        input.passwordTextFieldDidEditEvent
                                    )
                                    .map(vaildInput)
                                    .asDriver(onErrorJustReturn: false)
        
        let checkEmailPassword = Observable
                                    .combineLatest(
                                        input.emailTextFieldDidEditEvent,
                                        input.passwordTextFieldDidEditEvent
                                    )
                                    .map(checkEmailPassword)
        
        input.nextButtonDidTapEvent.withLatestFrom(checkEmailPassword).subscribe(onNext: { [weak self] isCheck in
            if isCheck {
                print("다음")
            } else {
                print("alert")
            }
        }).disposed(by: disposeBag)
        
        return Output(nextButtonEnable: nextButtonEnable)
    }
    
    func checkEmailPassword(email: String, password: String) -> Bool {
        // API connect
        return email == "test" && password == "test"
    }
    
    func vaildInput(email: String, password: String) -> Bool {
        return email.isEmpty == false && password.isEmpty == false
    }
}
