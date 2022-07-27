//
//  ProfileViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import RxSwift
import RxRelay

class ProfileViewModel: ViewModelType {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var userDeatil = BehaviorRelay<UserDetail>(value: UserDetail.defaultData)
    
    var userId: String?
    var isMyPage: Bool
    
    init (coordinator: ProfileCoordinator, useCase: ProfileUseCase, userId: String?) {
        self.coordinator = coordinator
        self.profileUseCase = useCase
        self.userId = userId
        
        if let id = userId {
            isMyPage = UserDataStorage.shared.userID == id ? true : false
        } else {
            isMyPage = false
        }
        
        getMyUserProfile()
    }
    
}

extension ProfileViewModel {
    
    struct Input {
        let didProfileButton: Observable<Void>
        
        let didJobTap: Observable<UITapGestureRecognizer>
        let didInterestTap: Observable<UITapGestureRecognizer>
        
        let didFolloweeTap: Observable<UITapGestureRecognizer>
        let didFollowerTap: Observable<UITapGestureRecognizer>
        
        let didContactTap: Observable<UITapGestureRecognizer>
        let didAccessibilityTap: Observable<UITapGestureRecognizer>
        let didPasswordTap: Observable<UITapGestureRecognizer>
        let didLogoutTap: Observable<UITapGestureRecognizer>
        let didSignOutTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let userDetail: Observable<UserDetail>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        // 프로필 수정 버튼
        input.didProfileButton.subscribe(onNext: { _ in
            self.coordinator?.pushProfileEditViewController()
        }).disposed(by: disposeBag)
        
        // 직업 관심사
        input.didJobTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.pushProfileEditViewController()   // TODO: 직업선택 Sheet 띄우기
        }).disposed(by: disposeBag)
        
        input.didInterestTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.pushProfileEditViewController()   // TODO: 관심사선택 Sheet 띄우기
        }).disposed(by: disposeBag)

        // 팔로워 팔로우
        input.didFolloweeTap.when(.recognized).subscribe(onNext: { _ in
            print("팔로워")
        }).disposed(by: disposeBag)

        input.didFollowerTap.when(.recognized).subscribe(onNext: { _ in
            print("팔로잉")
        }).disposed(by: disposeBag)

        // 하단
        input.didContactTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.pushContactViewController()
        }).disposed(by: disposeBag)
        
        input.didAccessibilityTap.when(.recognized).subscribe(onNext: { _ in
            print("접근성")
        }).disposed(by: disposeBag)

        input.didPasswordTap.when(.recognized).subscribe(onNext: { _ in
            self.coordinator?.pushPasswordChangeViewController()
        }).disposed(by: disposeBag)
        
        input.didLogoutTap.when(.recognized).subscribe(onNext: { _ in
            print("로그아웃")
        }).disposed(by: disposeBag)
        
        input.didSignOutTap.when(.recognized).subscribe(onNext: { _ in
            print("회원탈퇴")
        }).disposed(by: disposeBag)

        return Output(userDetail: userDeatil.asObservable())
    }
    
}

extension ProfileViewModel {
    
    /// 내 프로필 가져오기
    private func getMyUserProfile() {
        
        self.profileUseCase.myProfileDetail().debug()
            .subscribe(onSuccess: { userData in
            PublishRelay<UserDetail>.just(userData).bind(to: self.userDeatil).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    /// 남의 프로필 가져오기
    private func getUserProfile(id: String) {
        PublishRelay<UserDetail>.just(UserDetail.defaultData).bind(to: self.userDeatil).disposed(by: self.disposeBag)
    }
}
