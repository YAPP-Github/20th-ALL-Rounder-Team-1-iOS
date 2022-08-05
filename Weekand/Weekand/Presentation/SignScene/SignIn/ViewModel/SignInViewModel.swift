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
        let isSelectAutoSign: BehaviorRelay<Bool>
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
        
        input.isSelectAutoSign
            .subscribe(onNext: { isChecked in
                UserDefaults.standard.set(isChecked, forKey: "autoSign")
            })
            .disposed(by: disposeBag)
                        
        input.nextButtonDidTapEvent
                .withLatestFrom(isCheckEmailPassword)
                .throttle(.seconds(4), latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] email, password in
                    self?.login(email: email, password: password)
                }).disposed(by: disposeBag)
    
        input.passwordFindButtonDidTapEvent.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.presentPasswordFindScene()
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
        
        self.signInUseCase.login(email: emailText, password: passwordText).subscribe(onSuccess: { [weak self] tokenData in
            TokenManager.shared.createTokens(accessToken: tokenData.accessToken, refreshToken: tokenData.refreshToken)
            self?.coordinator?.showMainScene()
        }, onFailure: { [weak self] error in
            if error.localizedDescription == SignInError.notMatchIdPassword.serverDescription {
                self?.coordinator?.showToastMessage(text: "이메일·비밀번호가 일치하지 않습니다.")
            } else {
                self?.coordinator?.showToastMessage(text: "네트워크 요청에 실패하였습니다")
            }
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
