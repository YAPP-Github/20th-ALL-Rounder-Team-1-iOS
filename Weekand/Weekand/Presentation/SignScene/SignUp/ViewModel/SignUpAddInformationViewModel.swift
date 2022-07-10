//
//  SignUpAddInformationViewModel.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/04.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpAddInfomationViewModel: ViewModelType {

    weak var coordinator: SignUpCoordinator?
    var signUpInput: SignUpInput
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?, signUpInput: SignUpInput) {
        self.coordinator = coordinator
        self.signUpInput = signUpInput
    }
    
    struct Input {
        let selectedJobs: PublishRelay<[String]>
        let selectedInterests: PublishRelay<[String]>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.selectedJobs.subscribe(onNext: { [weak self] jobs in
            self?.signUpInput.jobs = jobs
        })
        .disposed(by: disposeBag)
        
        input.selectedInterests.subscribe(onNext: { [weak self] interests in
            self?.signUpInput.interests = interests
        })
        .disposed(by: disposeBag)

        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushTermsViewController(signUpInput: self.signUpInput)
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
