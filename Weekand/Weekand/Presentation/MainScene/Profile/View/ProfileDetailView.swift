//
//  ProfileDetailView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/21.
//

import UIKit

class ProfileDetailView: UIView {
    
    // 한줄목표 블록
    lazy var goalTitleLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray600
        $0.text = "한줄목표"
    }
    
    lazy var goalLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
    }
    
    lazy var goalBlock = UIStackView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        
        $0.spacing = 8
        $0.axis = .vertical
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 13, left: 16, bottom: 9, right: 16)
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
        [goalTitleLabel, goalLabel].forEach { goalBlock.addArrangedSubview($0) }
        
        [goalBlock].forEach { self.parentStack.addArrangedSubview($0)}
        
        self.addSubview(parentStack)
        parentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension ProfileDetailView {
    func setUpData(goal: String, jobs: [String], interests: [String], follower: Int, followee: Int) {
        goalLabel.text = goal
        
    }
}
