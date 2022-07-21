//
//  ProfileDetailView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import UIKit

/// 프로필 화면 회색 부분
class ProfileDetailView: UIView {
    
    // 한줄목표 블록
    lazy var goalBlock = ProfileDetailBlockView(title: "한줄 목표")
        
    lazy var followeeBlock = ProfileDetailInteractoinBlockView(title: "팔로워")
    lazy var followerBlock = ProfileDetailInteractoinBlockView(title: "팔로잉")
    
    lazy var followStack = UIStackView().then {
        $0.spacing = 12
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }

    
    lazy var parentStack = UIStackView().then {
        $0.spacing = 12
        $0.axis = .vertical
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        self.backgroundColor = .gray100
    }
    
    private func configureUI() {
        
        [followeeBlock, followerBlock].forEach { followStack.addArrangedSubview($0) }
        
        [goalBlock, followStack].forEach { self.parentStack.addArrangedSubview($0)}
        
        self.addSubview(parentStack)
        parentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
}

extension ProfileDetailView {
    func setUpData(goal: String, jobs: [String], interests: [String], follower: Int, followee: Int) {
        goalBlock.setContentText(content: goal)
        
        followeeBlock.setContentInt(content: followee)
        followerBlock.setContentInt(content: follower)
    }
}
