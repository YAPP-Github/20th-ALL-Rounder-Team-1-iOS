//
//  EmojiTableVIewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/12.
//

import Foundation
import UIKit
import SnapKit
import Then

class EmojiTableViewCell: UITableViewCell {
    
    static let identifier = "EmojiTableViewCell"
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.image = UIImage(named: "default.person")
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.body1()
    }
    
    lazy var emoji = UIImageView()
    
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    private func configureUI() {
        
        [profileImageView, nameLabel, emoji].forEach { stackView.addArrangedSubview($0) }
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        emoji.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(56)
        }
    }
}

extension EmojiTableViewCell {
    func setUpCell(_ data: EmojiGiver) {
        
        nameLabel.text = data.name
        emoji.image = UIImage(named: data.emoji.imageName)
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: data.imagePath) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
    
    }
}
