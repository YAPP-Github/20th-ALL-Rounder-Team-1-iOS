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

class MyProfileViewController: UIViewController {
    
    var viewModel: MyProfileViewModel?
    private let disposeBag = DisposeBag()
    
    // 상단 유저정보
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.head1()
        $0.textColor = .gray900
    }
    
    lazy var emailLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray400
    }
    
    lazy var profileLabelStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
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
    }
    
    // 프로필 수정 or 팔로우 버튼
    lazy var profileButton = WDefaultButton(title: "프로필 수정", style: .tint, font: WFont.subHead1())
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        
    }
    
    private func configureUI() {
        
        // 유저 프로필
        [nameLabel, emailLabel].forEach { profileLabelStack.addArrangedSubview($0) }
        [profileLabelStack, profileImageView].forEach { profileBarStack.addArrangedSubview($0) }
        profileLabelStack.setContentHuggingPriority(.required, for: .vertical)
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.width.equalTo(profileLabelStack.snp.height)
        }
        
        [profileBarStack, profileButton].forEach { self.view.addSubview($0) }
        profileBarStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(profileBarStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        

    }
    
    private func bindViewModel() {
        
    }
    
    
}
