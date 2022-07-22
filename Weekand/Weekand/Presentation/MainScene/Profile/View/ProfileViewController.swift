//
//  ProfileViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/19.
//

import Foundation
import UIKit
import RxSwift
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
    }
    
    lazy var profileBarStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 20
        $0.alignment = .center
    }
    
    // 프로필 수정 or 팔로우 버튼
    lazy var profileButton = WDefaultButton(title: "프로필 수정", style: .tint, font: WFont.subHead1())
    
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
    }
    
    private func setUpView() {
        
        self.view.backgroundColor = .backgroundColor
        
        // TODO: 서버연결 후 수정
        nameLabel.text = "이건두"
        emailLabel.text = "dei313r@mail.com"
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80") else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        detailBar.setUpData(
            goal: "오늘도 행복한 하루를 보내자 아자아자 화이팅",
            jobs: ["직장인", "iOS"], interests: [],
            follower: 0, followee: 312
        )
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
        
    }
    
    
}
