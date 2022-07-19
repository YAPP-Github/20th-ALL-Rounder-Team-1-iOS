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
    private let signInUseCase: SignInUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignInCoordinator?, signInUseCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = signInUseCase
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
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonEnable = Observable
                                    .combineLatest(
                                        input.emailTextFieldDidEditEvent,
                                        input.passwordTextFieldDidEditEvent
                                    )
                                    .map(vaildInput)
                                    .asDriver(onErrorJustReturn: false)
        
        let isCheckEmailPassword = Observable
                                    .combineLatest(
                                        input.emailTextFieldDidEditEvent,
                                        input.passwordTextFieldDidEditEvent
                                    )
                        
        input.nextButtonDidTapEvent
                .withLatestFrom(isCheckEmailPassword)
                .distinctUntilChanged { $0 == $1 }
                .subscribe(onNext: { [weak self] email, password in
                    self?.login(email: email, password: password)
                }).disposed(by: disposeBag)
    
        input.passwordFindButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.presentPasswordFindScene()
        }).disposed(by: disposeBag)
    
        return Output(
                nextButtonEnable: nextButtonEnable
        )
    }
    
    func vaildInput(email: String, password: String) -> Bool {
        return email.isEmpty == false && password.isEmpty == false
    }
}

extension SignInViewModel {
    private func login(email: String, password: String) {
        let emailText = email.trimmingCharacters(in: [" "])
        let passwordText = password.trimmingCharacters(in: [" "])
        
        self.signInUseCase.login(email: emailText, password: passwordText).subscribe(onSuccess: { tokenData in
            UserDataStorage.shared.setAccessToken(token: tokenData.accessToken)
            self.userID()
        }, onFailure: { _ in
            self.coordinator?.showToastMessage()
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    private func userID() {
        self.signInUseCase.userID().subscribe(onSuccess: { id in
            UserDataStorage.shared.setUserID(id: id)
            self.coordinator?.showMainScene()
        }, onFailure: { _ in
            self.coordinator?.showToastMessage()
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
