//
//  ProfileViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import UIKit
import RxSwift
import RxGesture
import Then
import SnapKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    private let disposeBag = DisposeBag()
    
    lazy var scrollView = UIScrollView()
    lazy var contenteView = UIView()
    
    // 상단 유저정보
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.head1()
        $0.textColor = .gray900
    }
    
    lazy var emailLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray600
    }
    
    lazy var profileLabelStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 6
    }
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        
        $0.image = UIImage(named: "default.person")
    }
    
    lazy var profileBarStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 20
        $0.alignment = .center
    }
    
    // 프로필 수정 or 팔로우 버튼
    lazy var profileButton = WDefaultButton(title: ProfileButtonType.edit.rawValue, style: .tint, font: WFont.subHead1())
    
    // 회색 부분 (목표, 직업 & 관심사, 팔로워 & 팔로잉)
    lazy var detailBar = ProfileDetailView()
        
    // 하단 버튼들
    lazy var contactLink = ProfileDetailHelperView(.contact)
    lazy var accessibilityLink = ProfileDetailHelperView(.accessibility)
    lazy var passwordLink = ProfileDetailHelperView(.password)
    lazy var logoutLink = ProfileDetailHelperView(.logout)
    lazy var signOutLink = ProfileDetailHelperView(.signOut)
    
    lazy var bottomStack = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
        
        accessibilityLink.isHidden = true   // TODO: 이후 업데이트
    }
    
    private func setUpView() {
        
        self.view.backgroundColor = .backgroundColor
        
    }
    
    private func configureUI() {
        
        // 유저 프로필
        [nameLabel, emailLabel].forEach { profileLabelStack.addArrangedSubview($0) }
        [profileLabelStack, profileImageView].forEach { profileBarStack.addArrangedSubview($0) }
        profileLabelStack.setContentHuggingPriority(.required, for: .vertical)
        profileLabelStack.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        profileImageView.setContentHuggingPriority(.required, for: .horizontal)
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        
        // 하단
        [contactLink, accessibilityLink, passwordLink, logoutLink, signOutLink].forEach { bottomStack.addArrangedSubview($0) }
        
        [profileBarStack, profileButton, detailBar, bottomStack].forEach { contenteView.addSubview($0) }
        profileBarStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(profileBarStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        detailBar.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(detailBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-64)
        }
        
        scrollView.addSubview(contenteView)
        contenteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    private func bindViewModel() {
        
        let input = ProfileViewModel.Input(
            
            didProfileButton: profileButton.rx.tap.map {
                self.profileButton.titleLabel?.text
            }.asObservable(),
            
            didJobTap: detailBar.jobInterestView.jobView.rx.tapGesture().asObservable(),
            
            didInterestTap: detailBar.jobInterestView.interestView.rx.tapGesture().asObservable(),
            didFolloweeTap: detailBar.followeeBlock.rx.tapGesture().asObservable(),
            didFollowerTap: detailBar.followerBlock.rx.tapGesture().asObservable(),
            
            didContactTap: contactLink.rx.tapGesture().asObservable(),
            didAccessibilityTap: accessibilityLink.rx.tapGesture().asObservable(),
            didPasswordTap: passwordLink.rx.tapGesture().asObservable(),
            didLogoutTap: logoutLink.rx.tapGesture().asObservable(),
            didSignOutTap: signOutLink.rx.tapGesture().asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.userDetail.subscribe(onNext: { userData in
            self.setData(user: userData)
        }).disposed(by: disposeBag)
    }
    
    
    
}

extension ProfileViewController {
    
    func setData(user: UserDetail) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: user.imagePath) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        detailBar.setUpData(
            goal: user.goal,
            jobs: user.job, interests: user.interest,
            follower: user.follower, followee: user.followee
        )
        
        // 다른유저의 프로필화면일 경우 일부 기능 수정 (Default = 내 프로필)
        if UserDataStorage.shared.userID != viewModel?.userId {
            
            bottomStack.isHidden = true
            
            if user.followed {
                profileButton.setUpStyle(ProfileButtonType.following.rawValue, font: WFont.subHead1(), style: .tint)
            } else {
                profileButton.setUpStyle(ProfileButtonType.follow.rawValue, font: WFont.subHead1(), style: .filled)
            }
            
            
            if user.job.isEmpty {
                
                if user.interest.isEmpty {
                    detailBar.jobInterestView.isHidden = true
                } else {
                    detailBar.jobInterestView.jobView.isHidden = true
                }
            } else if user.interest.isEmpty {
                detailBar.jobInterestView.interestView.isHidden = true
            }
        }
    }
    
    
}
