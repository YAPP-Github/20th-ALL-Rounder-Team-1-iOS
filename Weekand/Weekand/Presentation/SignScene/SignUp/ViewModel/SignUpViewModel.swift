//
//  SignUpViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {

    weak var coordinator: SignUpCoordinator?
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?, signUpUseCase: SignUpUseCase) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    let duplicatedEmail = PublishRelay<Bool>()
    let checkedAuthenticationNumber = PublishRelay<Bool>()
    let checkedNickName = PublishRelay<Bool>()
    
    var email: String = ""
    
    struct Input {
        let emailTextFieldDidEditEvent: Observable<String>
        let emailButtonDidTapEvent: Observable<Void>
        let authNumberTextFieldDidEditEvent: Observable<String>
        let authNumberButtonDidTapEvent: Observable<Void>
        let nickNameTextFieldDidEditEvent: Observable<String>
        let nickNameButtonDidTapEvent: Observable<Void>
        let passwordTextFieldDidEditEvent: Observable<String>
        let passwordTextFieldDidEndEditEvent: Observable<Void>
        let passwordCheckTextFieldDidEditEvent: Observable<String>
        let passwordCheckTextFieldDidEndEditEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var vaildEmail: Driver<(String, Bool)>
        var duplicatedEmail: PublishRelay<Bool>
        var checkAuthenticationNumber: PublishRelay<Bool>
        var checkNickName: PublishRelay<Bool>
        var vaildPassword: Driver<Bool>
        var accordPassword: Driver<Bool>
        var nextButtonEnable: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let vaildEmail = input.emailTextFieldDidEditEvent.map(vaildEmail).asObservable()
        let vaildEmailWithTap = input.emailButtonDidTapEvent
                                        .withLatestFrom(vaildEmail)
                                        .distinctUntilChanged { $0 == $1 }
        
        let checkAuthenticationNumberWithTap = input.authNumberButtonDidTapEvent
                                                    .withLatestFrom(input.authNumberTextFieldDidEditEvent)
                                                    .distinctUntilChanged { $0 == $1 }

        let checkNickNameWithTap = input.nickNameButtonDidTapEvent
                                        .withLatestFrom(input.nickNameTextFieldDidEditEvent)
                                        .map(vaildNickname)
                                        .distinctUntilChanged { $0 == $1 }
        
        let vaildPassword = input.passwordTextFieldDidEditEvent.map(validPassword).asObservable()
        let vaildPasswordWithEndEdit = input.passwordTextFieldDidEndEditEvent.withLatestFrom(vaildPassword)
        
        let accordPassword = Observable.combineLatest(input.passwordTextFieldDidEditEvent, input.passwordCheckTextFieldDidEditEvent).map(accordPassword).asObservable()
        let accordPasswordWithEndEdit = input.passwordCheckTextFieldDidEndEditEvent.withLatestFrom(accordPassword)
        
        let nextButtonEnable = Observable.combineLatest(vaildEmailWithTap, checkedAuthenticationNumber, checkedNickName, vaildPassword, accordPassword).map { $0.1 && $1 && $2 && $3 && $4 }
        
        vaildEmailWithTap
            .subscribe(onNext: { [weak self] email, isValid in
            if isValid {
                self?.sendAuthKey(email)
            }
        }).disposed(by: disposeBag)
        
        checkAuthenticationNumberWithTap
            .subscribe(onNext: { [weak self] authKey in
                self?.vaildAuthKey(authKey)
        }).disposed(by: disposeBag)
        
        checkNickNameWithTap
            .subscribe(onNext: { [weak self] nickname, isValid in
                if isValid {
                    self?.checkDuplicateNickname(nickname)
                } else {
                    self?.coordinator?.showToastMessage()
                }
                
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushAddInformationViewController()
        }, onError: { _ in
            
        }).disposed(by: disposeBag)
        
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
        
        return Output(
            vaildEmail: vaildEmailWithTap.asDriver(onErrorJustReturn: ("", false)),
            duplicatedEmail: duplicatedEmail,
            checkAuthenticationNumber: checkedAuthenticationNumber,
            checkNickName: checkedNickName,
            vaildPassword: vaildPasswordWithEndEdit.asDriver(onErrorJustReturn: false),
            accordPassword: accordPasswordWithEndEdit.asDriver(onErrorJustReturn: false),
            nextButtonEnable: nextButtonEnable.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func vaildEmail(email: String) -> (String, Bool) {
        let emailText = email.trimmingCharacters(in: [" "])
        guard let regex = try? NSRegularExpression(
            pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
            options: [.caseInsensitive]
        )
        else {
            assertionFailure("Regex not valid")
            return (emailText, false)
        }
        
        let regexFirstMatch = regex
            .firstMatch(
                in: email,
                options: [],
                range: NSRange(location: 0, length: email.count)
            )
        
        return (emailText, regexFirstMatch != nil)
    }
    
    private func vaildNickname(_ nickName: String) -> (String, Bool) {
        if nickName.count >= 2 && nickName.count < 11 {
            return (nickName, true)
        }
        return (nickName, false)
    }
    
    private func validPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func accordPassword(password: String, passwordforCheck: String) -> Bool {
        return password == passwordforCheck
    }
}

// network

extension SignUpViewModel {
    private func sendAuthKey(_ email: String) {
        self.signUpUseCase.sendAuthKey(email: email)
            .subscribe(onSuccess: { isSucceed in
            if isSucceed {
                self.coordinator?.presentPopViewController(titleText: "안내", informText: "인증번호가 발송되었습니다.")
                self.email = email
            }
        }, onFailure: { error in
            if error.localizedDescription == NetworkError.duplicatedError.localizedDescription {
                self.duplicatedEmail.accept(true)
            }
            // TODO: error 처리
        }, onDisposed: nil)
        .disposed(by: self.disposeBag)
    }
    
    private func vaildAuthKey(_ key: String) {
        self.signUpUseCase.vaildAuthKey(key: key, email: email)
            .subscribe(onSuccess: { isValid in
                if isValid {
                    self.checkedAuthenticationNumber.accept(true)
                } else {
                    self.checkedAuthenticationNumber.accept(false)
                }
            }, onFailure: { _ in
                self.checkedAuthenticationNumber.accept(false)
            }, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    private func checkDuplicateNickname(_ nickName: String) {
        self.signUpUseCase.checkDuplicateNickname(nickName: nickName)
            .subscribe(onSuccess: { isValid in
                if isValid {
                    self.checkedNickName.accept(true)
                } else {
                    // self.checkedNickName.accept(false)
                    self.checkedNickName.accept(true)
                }
            }, onFailure: { _ in
                // self.checkedNickName.accept(false)
                self.checkedNickName.accept(true)
            }, onDisposed: nil)
            .disposed(by: disposeBag)

    }
}
