//
//  ContactViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/24.
//

import Foundation
import RxSwift
import RxRelay

class ContactViewModel: ViewModelType {

    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var contactText = ""
    var isSuccess = PublishRelay<Bool>()
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
    }
    
}

extension ContactViewModel {
    
    struct Input {
        let contactString: Observable<String?>
        let didButtonTap: Observable<Void>
    }
    
    struct Output {
        let serverResult: Observable<Bool>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.contactString.subscribe(onNext: { text in
            if let text = text {
                self.contactText = text
            }
            
        }).disposed(by: disposeBag)
        
        input.didButtonTap.subscribe(onNext: { _ in
            
            self.sendContact(message: self.contactText)
            
        }).disposed(by: disposeBag)
                
        return Output(
            serverResult: isSuccess.asObservable()
        )
    }
}

extension ContactViewModel {
    func sendContact(message: String) {
        self.profileUseCase.sendContact(message: message).subscribe(onSuccess: { isSucceed in
            if isSucceed {
                self.coordinator?.pushContactCompleteViewController()
            } else {
                PublishRelay<Bool>.just(false).bind(to: self.isSuccess).disposed(by: self.disposeBag)
            }
            
        }, onFailure: { _ in
            PublishRelay<Bool>.just(false).bind(to: self.isSuccess).disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
    
}
