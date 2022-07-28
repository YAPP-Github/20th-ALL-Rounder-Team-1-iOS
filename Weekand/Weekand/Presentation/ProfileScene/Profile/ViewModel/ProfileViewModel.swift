//
//  ProfileViewModel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import RxSwift
import RxRelay

enum ProfileButtonType: String {
    case edit = "프로필 수정"
    case following = "팔로잉"
    case follow = "팔로우"
}

class ProfileViewModel: ViewModelType {
    
    weak var coordinator: ProfileCoordinator?
    private let profileUseCase: ProfileUseCase
    private let disposeBag = DisposeBag()
    
    var userDeatil = BehaviorRelay<UserDetail>(value: UserDetail.defaultData)
    var buttonState = BehaviorRelay<ProfileButtonType>(value: ProfileButtonType.edit)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
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
        
        getUserProfile(id: userId)
    }
    
}

extension ProfileViewModel {
    
    struct Input {
        let didProfileButton: Observable<String?>
        
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
        let buttonState: Observable<ProfileButtonType>
        let errorMessage: Observable<String?>
    }
    
    @discardableResult
    func transform(input: Input) -> Output {
        
        // 프로필 수정 버튼
        input.didProfileButton.subscribe(onNext: { text in
            
            guard let text = text else { return }
            guard let type = ProfileButtonType(rawValue: text) else { return }
            
            switch type {
            case .edit:
                self.coordinator?.pushProfileEditViewController()
            // 팔로우 버튼 터치 -> 팔로우 추가 동작
            case .follow:
                guard let id = self.userId else { return }
                self.followUser(id: id)
                   
            // 팔로잉 버튼 터치 -> 팔로우 취소 동작
            case .following:
                guard let id = self.userId else { return }
                self.unfollowUser(id: id) 
            }

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

        return Output(
            userDetail: userDeatil.asObservable(),
            buttonState: buttonState.asObservable(),
            errorMessage: errorMessage.asObservable()
        )
    }
    
}

extension ProfileViewModel {
    
    /// 유저 프로필 가져오기
    private func getUserProfile(id: String?) {
        
        self.profileUseCase.profileDetail(id: id)
            .subscribe(onSuccess: { userData in
            PublishRelay<UserDetail>.just(userData).bind(to: self.userDeatil).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    
    private func followUser(id: String) {
        
        self.profileUseCase.createFollowee(id: id).subscribe(onSuccess: { result in
            BehaviorRelay<ProfileButtonType>.just(.following).bind(to: self.buttonState).disposed(by: self.disposeBag)
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            BehaviorRelay<String?>.just("\(error)").bind(to: self.errorMessage).disposed(by: self.disposeBag)
        }, onDisposed: nil)
        .disposed(by: disposeBag)

    }
    
    private func unfollowUser(id: String) {
        
        self.profileUseCase.deleteFollowee(id: id).subscribe(onSuccess: { result in
            BehaviorRelay<ProfileButtonType>.just(.follow).bind(to: self.buttonState).disposed(by: self.disposeBag)

        }, onFailure: { error in
            print("\(#function) Error: \(error)")
            BehaviorRelay<String?>.just("\(error)").bind(to: self.errorMessage).disposed(by: self.disposeBag)
        }, onDisposed: nil)
        .disposed(by: disposeBag)
    
    }
    
}
