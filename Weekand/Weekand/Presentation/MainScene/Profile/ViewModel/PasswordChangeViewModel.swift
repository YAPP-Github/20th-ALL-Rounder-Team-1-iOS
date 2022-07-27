//
//  PasswordChangeViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import Foundation
import RxSwift
import RxRelay

class PasswordChangeViewModel: ViewModelType {

    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var currnetPassword: String?
    var newPassword: String?
    var checkPassword: String?
    
    var passwordInvalid = PublishRelay<Void>()
    var passwordIdentical = PublishRelay<Bool>()
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
    }

}

extension PasswordChangeViewModel {
    
    struct Input {
        let currentPassword: Observable<String>
        let newPassword: Observable<String>
        let checkPassword: Observable<String>
        
        let didConfirmButtonTap: Observable<Void>
    }
    
    struct Output {
        let passwordInvalid: Observable<Void>
        let passwordIdentical: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.currentPassword.subscribe(onNext: { text in
            self.currentInputAction(input: text)
        }).disposed(by: disposeBag)

        input.newPassword.subscribe(onNext: { text in
            self.newInputAction(input: text)
        }).disposed(by: disposeBag)

        input.checkPassword.subscribe(onNext: { text in
            self.checkInputAction(input: text)
        }).disposed(by: disposeBag)

        
        return Output(
            passwordInvalid: passwordInvalid.asObservable(),
            passwordIdentical: passwordIdentical.asObservable()
        )
    }
}

extension PasswordChangeViewModel {
    
    func currentInputAction(input: String) {
        self.currnetPassword = input
        PublishRelay<Bool>.just(true).bind(to: passwordIdentical).disposed(by: disposeBag)
    }
    
    /// 새 비밀번호 입력시 동작
    func newInputAction(input: String) {
        self.newPassword = input
        
        guard let checkPassword = self.checkPassword else { return }
        
        PublishRelay<Bool>.just(newPassword == checkPassword).bind(to: passwordIdentical).disposed(by: disposeBag)
    }
    
    /// 비밀번호 확인 입력시 동작
    func checkInputAction(input: String) {
        self.checkPassword = input
        
        guard let newPassword = self.newPassword else { return }
        
        PublishRelay<Bool>.just(newPassword == checkPassword).bind(to: passwordIdentical).disposed(by: disposeBag)
    }
}
