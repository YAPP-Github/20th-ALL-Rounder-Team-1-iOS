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
    private var signUpModel: SignUpModel
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?, signUpModel: SignUpModel) {
        self.coordinator = coordinator
        self.signUpModel = signUpModel
    }
    
    struct Input {
        let selectedJobs: PublishRelay<[String]>
        let selectedInterests: PublishRelay<[String]>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.selectedJobs.subscribe(onNext: { [weak self] jobs in
            self?.signUpModel.jobs = jobs
        })
        .disposed(by: disposeBag)
        
        input.selectedInterests.subscribe(onNext: { [weak self] interests in
            self?.signUpModel.interests = interests
        })
        .disposed(by: disposeBag)

        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushTermsViewController(signUpModel: self.signUpModel)
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
