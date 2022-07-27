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
    
    var alertText = PublishSubject<String>()
    var userDetail = BehaviorRelay<UserDetail>(value: UserDetail.defaultData)
    var userUpdate = PublishRelay<UserUpdate>()
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
        getMyUserProfile(id: UserDataStorage.shared.userID)
        
        userUpdate.subscribe(onNext: { update in
            print(update)
            
            if update.name.count < 3 {
                PublishRelay<String>.just("닉네임은 최소 3글자 이상이어야 합니다.").bind(to: self.alertText).disposed(by: self.disposeBag)
            }
            
        }).disposed(by: disposeBag)
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
        let alertText: Observable<String>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didImageTap.when(.recognized).subscribe(onNext: { _ in
            print("Image")
        }).disposed(by: disposeBag)
        
        input.didJobTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.presentJobInformationSheet()
        }).disposed(by: disposeBag)
        
        input.didInterestTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.presentInterestsInformationSheet()
        }).disposed(by: disposeBag)
        
        input.didButtonTap.subscribe(onNext: { update in
            print(update)
        }).disposed(by: disposeBag)
        
        return Output(
            userDetail: userDetail.asObservable(),
            alertText: alertText.asObservable()
        )
    }
}

extension ProfileEditViewModel {
    
    private func getMyUserProfile(id: String?) {
        
        self.profileUseCase.profileDetail(id: id)
            .subscribe(onSuccess: { userData in
                BehaviorRelay<UserDetail>.just(userData).bind(to: self.userDetail).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
