//
//  WeekCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WeekCell"
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                textLabel.backgroundColor = .mainColor
                textLabel.textColor = .white
            } else {
                textLabel.backgroundColor = .subColor
                textLabel.textColor = .gray900
            }
        }
    }
    
    lazy var textLabel = WTextLabel().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.textAlignment = .center
        $0.backgroundColor = .subColor
        $0.textColor = .gray900
        $0.font = WFont.body1()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
    
    private func setupView() {
        
    }

    public func configure(text: String) {
        textLabel.text = text
    }
}
