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
    var message = PublishRelay<String>()
    
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
        let message: Observable<String>
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
        
        input.didConfirmButtonTap.subscribe(onNext: { _ in
            
            guard let old = self.currnetPassword else { return }
            guard let new = self.newPassword else { return }
            
            self.updatePassword(old: old, new: new)
        }).disposed(by: disposeBag)

        
        return Output(
            passwordInvalid: passwordInvalid.asObservable(),
            passwordIdentical: passwordIdentical.asObservable(),
            message: message.asObservable()
        )
    }
}

// MARK: Validation
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

// MARK: Network
extension PasswordChangeViewModel {
    
    func updatePassword(old: String, new: String) {
        
        self.profileUseCase.updatePassword(old: old, new: new).subscribe(onSuccess: { isSucceed in
            if isSucceed {
                
                self.coordinator?.profileViewController.showToast(message: "비밀번호가 변경되었습니다")
                
                self.coordinator?.navigationController.popViewController(animated: true)
                
            } else {
                PublishRelay<String>.just("비밀번호가 변경 실패").bind(to: self.message).disposed(by: self.disposeBag)
            }
            
        }, onFailure: { error in
            
            var message = "\(error)"
            
            if message == "비밀번호가 일치하지 않습니다." {
                message = "현재 비밀번호를 확인해주세요 "
            }
            
            PublishRelay<String>.just(message).bind(to: self.message).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
}
