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
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.contactString.subscribe(onNext: { text in
            if let text = text {
                self.contactText = text
            }
            
        }).disposed(by: disposeBag)
        
        input.didButtonTap.subscribe(onNext: { _ in
            // TODO: 문의 완료 화면으로 이동
            print("Text: \(self.contactText)")
        }).disposed(by: disposeBag)
                
        return Output()
    }
}
