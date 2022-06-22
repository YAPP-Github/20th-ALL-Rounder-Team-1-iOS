//
//  MainCollectionViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/20.
//

import UIKit

/// 메인화면 가장 위쪽 팔로잉 목록 CollectionView에 쓰이는 Cell
class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainCollectionViewCell"
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    lazy var nameLabel = UILabel().then {
        
        $0.font = WFont.body4()
        $0.textColor = .gray600
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        [ profileImageView, nameLabel ].forEach { self.addSubview($0) }
        profileImageView.setContentHuggingPriority(.required, for: .horizontal)
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(profileImageView.snp.width)
            make.top.left.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}

extension MainCollectionViewCell {
    
    func setUpCell(name: String, imagePath: String?) {
        
        nameLabel.text = name
        
        if let imagePath = imagePath {
            DispatchQueue.global().async {
                guard let imageURL = URL(string: imagePath) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            
            profileImageView.backgroundColor = .mainColor
        }
    }
    
    /// 선택 여부에 따라 프로필 이미지 테두리 On/Off
    func processSelected(isSelected: Bool) {
        
        if isSelected {
            profileImageView.layer.borderWidth = 3
        } else {
            profileImageView.layer.borderWidth = 0
        }
        
    }
}