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
    
    var updateImage: UIImage?
    var updateDetail: UserUpdate?
    
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        
        getMyUserProfile(id: UserDataStorage.shared.userID)
        
        userUpdate.subscribe(onNext: { update in
            
            guard let name = update.name?.count else { return }
            if name < 3 {
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
        
        let profileDataChanged: Observable<UserUpdate>
        let profileImageChanged: Observable<UIImage>
    }
    
    struct Output {
        let userDetail: Observable<UserDetail>
        let alertText: Observable<String>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        input.didImageTap.when(.recognized).subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        
        input.didJobTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.presentJobInformationSheet()
        }).disposed(by: disposeBag)
        
        input.didInterestTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.presentInterestsInformationSheet()
        }).disposed(by: disposeBag)
        
        input.didButtonTap.subscribe(onNext: { _ in
            
            
        }).disposed(by: disposeBag)
        
        input.profileDataChanged.subscribe(onNext: { updatedDetail in
            self.updateDetail = updatedDetail
        }).disposed(by: disposeBag)
        
        input.profileImageChanged.subscribe(onNext: { updatedImage in
            self.updateImage = updatedImage
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
                
                self.updateDetail = UserUpdate(name: userData.name, goal: userData.goal, imageFileName: nil, job: userData.job, interest: userData.interest)
                
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
