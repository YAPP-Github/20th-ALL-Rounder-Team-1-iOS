//
//  SignUpTermsViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/04.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpTermsViewModel: ViewModelType {

    weak var coordinator: SignUpCoordinator?
    private let signUpUseCase: SignUpUseCase
    private var signUpModel: SignUpModel
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?, signUpUseCase: SignUpUseCase, signUpModel: SignUpModel) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
        self.signUpModel = signUpModel
    }
    
    struct Input {
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {

        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.signUpModel.signUpAgreed = true
            
            self.SignUp(self.signUpModel)
        })
        .disposed(by: disposeBag)
        
        return Output()
    }
}

extension SignUpTermsViewModel {
    private func SignUp(_ signUpModel: SignUpModel) {
        self.signUpUseCase.SignUp(signUpModel: signUpModel)
            .subscribe(onSuccess: { isSucceed in
                if isSucceed {
                    self.coordinator?.finish()
                } else {
                    self.coordinator?.presentPopViewController(
                                        titleText: "오류",
                                        informText: "회원가입에 실패하였습니다.",
                                        dismissParentCoordinator: false)
                }
            }, onFailure: { _ in
                self.coordinator?.presentPopViewController(
                                    titleText: "오류",
                                    informText: "회원가입에 실패하였습니다.",
                                    dismissParentCoordinator: false)
            }, onDisposed: nil)
            .disposed(by: disposeBag)

    }
}
