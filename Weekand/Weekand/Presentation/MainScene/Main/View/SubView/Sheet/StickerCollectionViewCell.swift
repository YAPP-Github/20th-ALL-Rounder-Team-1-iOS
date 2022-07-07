//
//  StickerCollectionViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import SnapKit
import Then

class StickerCollectionViewCell: UICollectionViewCell {
    
    lazy var emojiBackground = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 40
    }
    
    lazy var emojiImageView = UIImageView()
    
    lazy var emojiNameLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        
    }
    
    private func configureUI() {
        
        [emojiBackground, emojiImageView, emojiNameLabel].forEach { self.contentView.addSubview($0) }
        emojiBackground.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(emojiBackground.snp.width)
        }
        
        emojiImageView.snp.makeConstraints { make in
            make.edges.equalTo(emojiBackground).inset(21.5)
            make.height.equalTo(emojiImageView.snp.width)
        }
        
        emojiNameLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiBackground.snp.bottom).inset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

// MARK: Setup
extension StickerCollectionViewCell {
    
    func setUpCell(emoji: Emoji) {
        
        emojiImageView.image = UIImage(named: emoji.imageName)
        emojiNameLabel.text = emoji.emojiName
    }
    
}
