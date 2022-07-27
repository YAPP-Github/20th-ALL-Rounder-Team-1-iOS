//
//  ProfileDetailJobInterestView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit

/// 직업 관심사 부분
class ProfileDetailJobInterestView: UIStackView {
    
    var jobView = ProfileDetailCollectionStackView()
    var interestView = ProfileDetailCollectionStackView()
    
    init () {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .vertical
        self.spacing = 0
        self.distribution = .fill
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    private func configureUI() {
        [jobView, interestView].forEach { self.addArrangedSubview($0) }
    }
    
}

extension ProfileDetailJobInterestView {
    
    func setData(jobs: [String], interests: [String]) {
        jobView.setData(title: "직업", content: jobs)
        interestView.setData(title: "관심사", content: interests)
    }
}
