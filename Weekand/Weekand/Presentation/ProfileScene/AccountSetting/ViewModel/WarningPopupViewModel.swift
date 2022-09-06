//
//  WarningPopupViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import Foundation
import RxSwift

class WarningPopupViewModel: ViewModelType {
    
    weak var coordinator: ResignWarningPopupCoordinator?
    private var disposeBag = DisposeBag()
    private let profileUseCase: ProfileUseCase

    init(coordinator: ResignWarningPopupCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
    }
    
    struct Input {
        let confirmButtonDidTapEvent: Observable<Void>
        let cancelButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.confirmButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
            self.deleteUser()
        }).disposed(by: disposeBag)
        
        input.cancelButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.dismiss()
        }).disposed(by: disposeBag)
        
        return Output()
    }
}

extension WarningPopupViewModel {
    private func deleteUser() {
        self.profileUseCase.deleteUser().subscribe(onSuccess: { isSucceed in
            if isSucceed {
                NotificationCenter.default.post(name: NSNotification.Name("showWeclomeScene"), object: nil, userInfo: nil)
                TokenManager.shared.deleteTokens()
                UserDefaults.standard.set(false, forKey: "autoSign")
            }
        }, onFailure: { error in
            print(error)
        })
        .disposed(by: disposeBag)
    }
}
