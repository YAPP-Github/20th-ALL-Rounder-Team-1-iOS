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
    private let disposeBag = DisposeBag()
    
    var userDeatil = BehaviorRelay<UserDetail>(value: UserDetail.defaultData)
    
    var userId: String?
    var isMyPage: Bool
    
    init (coordinator: ProfileCoordinator, userId: String?) {
        self.coordinator = coordinator
        self.userId = userId
        
        if let id = userId {
            isMyPage = UserDataStorage.shared.userID == id ? true : false
        } else {
            isMyPage = false
        }
        
        // TODO: 서버 연결 후 삭제
        PublishRelay<UserDetail>.just(UserDetail(
            userId: "1",
            email: "dei313r@mail.com",
            name: "이건두",
            goal: "오늘도 행복한 하루를 보내자 아자아자 화이팅",
            imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80",
            followee: 31,
            follower: 0,
            job: ["직장인", "개발"],
            interest: [])
        ).bind(to: userDeatil).disposed(by: disposeBag)
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
        
        input.didProfileButton.subscribe(onNext: { _ in
            print("프로필")
        }).disposed(by: disposeBag)
        
        // 직업 관심사
        input.didJobTap.when(.recognized).subscribe(onNext: { _ in
            print("직업")
        }).disposed(by: disposeBag)
        
        input.didInterestTap.when(.recognized).subscribe(onNext: { _ in
            print("관심사")
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
            print("문의하기")
        }).disposed(by: disposeBag)
        
        input.didAccessibilityTap.when(.recognized).subscribe(onNext: { _ in
            print("접근성")
        }).disposed(by: disposeBag)

        input.didPasswordTap.when(.recognized).subscribe(onNext: { _ in
            print("비밀번호")
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
