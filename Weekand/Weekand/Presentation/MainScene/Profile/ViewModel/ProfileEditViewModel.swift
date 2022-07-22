//
//  ProfileEditViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit
import RxSwift
import RxRelay

class ProfileEditViewModel: ViewModelType {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var userDetail = BehaviorRelay<UserDetail>(value: UserDetail.defaultData)
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
        getMyUserProfile()
    }
    
}

extension ProfileEditViewModel {
    
    struct Input {
        let didImageTap: Observable<UITapGestureRecognizer>
        let didJobTap: Observable<UITapGestureRecognizer>
        let didInterestTap: Observable<UITapGestureRecognizer>
        let didButtonTap: Observable<Void>
    }
    
    struct Output {
        let userDetail: Observable<UserDetail>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didImageTap.when(.recognized).subscribe(onNext: { _ in
            print("Image")
        }).disposed(by: disposeBag)
        
        input.didJobTap.when(.recognized).subscribe(onNext: { _ in
            print("Job")
        }).disposed(by: disposeBag)
        
        input.didInterestTap.when(.recognized).subscribe(onNext: { _ in
            print("Interest")
        }).disposed(by: disposeBag)
        
        input.didButtonTap.subscribe(onNext: { _ in
            print("Button")
        }).disposed(by: disposeBag)
        
        return Output(userDetail: userDetail.asObservable())
    }
}

extension ProfileEditViewModel {
    
    private func getMyUserProfile() {
        
        self.profileUseCase.myProfileDetail().debug()
            .subscribe(onSuccess: { userData in
                BehaviorRelay<UserDetail>.just(userData).bind(to: self.userDetail).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
