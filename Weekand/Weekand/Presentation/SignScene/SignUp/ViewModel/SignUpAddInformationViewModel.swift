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
    private let disposeBag = DisposeBag()
    
    init(coordinator: SignUpCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let selectedJobs: PublishRelay<[String]>
        let selectedInterests: PublishRelay<[String]>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        
        input.selectedJobs.subscribe(onNext: { [weak self] jobs in
            print(jobs.count)
        }, onError: { _ in
            
        }).disposed(by: disposeBag)
        
        input.selectedInterests.subscribe(onNext: { [weak self] interests in
            print(interests.count)
        }, onError: { _ in
            
        }).disposed(by: disposeBag)

        input.nextButtonDidTapEvent.subscribe(onNext: {
            self.coordinator?.pushTermsViewController()
        }, onError: { _ in
            
        }).disposed(by: disposeBag)
        
        return Output()
    }
}
