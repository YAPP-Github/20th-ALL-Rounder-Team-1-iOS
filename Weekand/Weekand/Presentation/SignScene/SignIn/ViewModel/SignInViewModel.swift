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
        let passwordFindButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var nextButtonEnable: Driver<Bool>
        var loginResult: Driver<Bool>
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
        
        input.passwordFindButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentPasswordFindScene()
        }).disposed(by: disposeBag)
        
        let loginResult = input.nextButtonDidTapEvent.withLatestFrom(checkEmailPassword)
        
        loginResult
            .subscribe(onNext: { [weak self] isValid in
            if isValid {
                self?.coordinator?.showMainScene()
            }
        }).disposed(by: disposeBag)
        
        return Output(
                nextButtonEnable: nextButtonEnable,
                loginResult: loginResult.asDriver(onErrorJustReturn: false)
        )
    }
    
    func checkEmailPassword(email: String, password: String) -> Bool {
        // API connect
        return email == "test" && password == "test"
    }
    
    func vaildInput(email: String, password: String) -> Bool {
        return email.isEmpty == false && password.isEmpty == false
    }
}
