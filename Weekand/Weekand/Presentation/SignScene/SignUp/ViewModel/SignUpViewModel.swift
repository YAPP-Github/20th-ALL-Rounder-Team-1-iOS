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
        let authNumberTextFieldDidEditEvent: Observable<String>
        let nickNameTextFieldDidEditEvent: Observable<String>
        let passwordTextFieldDidEditEvent: Observable<String>
        let passwordCheckTextFieldDidEditEvent: Observable<String>
    }
    
    struct Output {
        var vaildEmail: Driver<Bool>
        var checkAuthenticationNumber: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let vaildEmail = input.emailTextFieldDidEditEvent.map(vaildEmail).asDriver(onErrorJustReturn: false)
        let checkAuthenticationNumber = input.authNumberTextFieldDidEditEvent.map(checkAuthenticationNumber).asDriver(onErrorJustReturn: false)
        
        return Output(vaildEmail: vaildEmail, checkAuthenticationNumber: checkAuthenticationNumber)
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
    
    private func checkAuthenticationNumber(authNumber: String) -> Bool {
        if authNumber == "1234" {
            return true
        }
        return false
    }
    
}
