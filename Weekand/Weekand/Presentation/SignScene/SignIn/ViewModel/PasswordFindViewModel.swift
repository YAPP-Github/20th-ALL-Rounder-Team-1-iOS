//
//  PasswordFindViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/28.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordFindViewModel: ViewModelType {
    weak var coordinator: PasswordFindCoordinator?
    private let signInUseCase: SignInUseCase
    private let disposeBag = DisposeBag()
    
    init(coordinator: PasswordFindCoordinator?, signInUseCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = signInUseCase
    }
    
    let invaildEmail = PublishRelay<String>()
    
    struct Input {
        let emailTextFieldDidEditEvent: Observable<String>
        let closeButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.emailTextFieldDidEditEvent
            .map(vaildEmail)
            .subscribe(onNext: { email, isVaild in
                if isVaild {
                    self.issueTempPassword(email: email)
                } else {
                    self.invaildEmail.accept("유효하지 않은 이메일입니다.")
                }
            }).disposed(by: disposeBag)
        
        input.closeButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.finish()
        }).disposed(by: disposeBag)
        
        return Output()
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
}

extension PasswordFindViewModel {
    
    func issueTempPassword(email: String) {
        self.signInUseCase.issueTempPassword(email: email)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    // 임시비밀번호가 발급되었습니다
                } else {
                    // 가입되지 않은 이메일입니다
                }
        }, onFailure: { _ in
            // 가입되지 않은 이메일입니다
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
}
