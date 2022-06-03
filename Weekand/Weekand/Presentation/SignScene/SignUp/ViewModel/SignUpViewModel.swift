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
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?) {
        self.coordinator = coordinator
    }
    
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
    }
    
    struct Output {
        var vaildEmail: Driver<Bool>
        var checkAuthenticationNumber: Driver<Bool>
        var checkNickName: Driver<Bool>
        var vaildPassword: Driver<Bool>
        var accordPassword: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let vaildEmail = input.emailButtonDidTapEvent
                                .withLatestFrom(
                                    input.emailTextFieldDidEditEvent
                                        .map(vaildEmail)
                                ).asDriver(onErrorJustReturn: false)
        
        let checkAuthenticationNumber = input.authNumberButtonDidTapEvent
                                .withLatestFrom(
                                    input.authNumberTextFieldDidEditEvent
                                        .map(checkAuthenticationNumber)
                                ).asDriver(onErrorJustReturn: false)
        
        let checkNickName = input.nickNameButtonDidTapEvent
                                .withLatestFrom(
                                    input.nickNameTextFieldDidEditEvent
                                        .map(checkNickName)
                                ).asDriver(onErrorJustReturn: false)
        
        let vaildPassword = input.passwordTextFieldDidEndEditEvent
                                    .withLatestFrom(
                                        input.passwordTextFieldDidEditEvent
                                            .map(validPassword)
                                    ).asDriver(onErrorJustReturn: false)
        
        let accordPassword = input.passwordCheckTextFieldDidEndEditEvent
                                    .withLatestFrom(
                                        Observable
                                            .combineLatest(input.passwordTextFieldDidEditEvent, input.passwordCheckTextFieldDidEditEvent)
                                            .map(accordPassword)
                                    ).asDriver(onErrorJustReturn: false)
        
        return Output(
            vaildEmail: vaildEmail,
            checkAuthenticationNumber: checkAuthenticationNumber,
            checkNickName: checkNickName,
            vaildPassword: vaildPassword,
            accordPassword: accordPassword
        )
    }
    
    private func vaildEmail(email: String) -> Bool {
        guard let regex = try? NSRegularExpression(
            pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
            options: [.caseInsensitive]
        )
        else {
            assertionFailure("Regex not valid")
            return false
        }
        
        let regexFirstMatch = regex
            .firstMatch(
                in: email,
                options: [],
                range: NSRange(location: 0, length: email.count)
            )
        
        return regexFirstMatch != nil
    }
    
    private func checkAuthenticationNumber(_ authNumber: String) -> Bool {
        if authNumber == "1234" {
            return true
        }
        return false
    }
    
    private func checkNickName(_ nickName: String) -> Bool {
        if nickName == "토게피" {
            return true
        }
        return false
    }
    
    private func validPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func accordPassword(password: String, passwordforCheck: String) -> Bool {
        return password == passwordforCheck
    }
}
