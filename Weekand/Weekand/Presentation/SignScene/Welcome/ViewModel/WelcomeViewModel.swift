//
//  WelcomeViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/01.
//

import Foundation
import RxSwift

class WelcomeViewModel: ViewModelType {
    weak var coordinator: WelcomeCoordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: WelcomeCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let didTapSignInButton: Observable<Void>
        let didTapSignUpButton: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didTapSignInButton
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showSignInScene()
            })
            .disposed(by: disposeBag)
        
        input.didTapSignUpButton
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showSignUpScene()
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
