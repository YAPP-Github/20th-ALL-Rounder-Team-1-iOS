//
//  AlarmTableViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/29.
//

import UIKit
import Then

class AlarmTableViewCell: UITableViewCell {
    
    static let identifier = "AlarmTableCell"
    
    lazy var iconImageView = UIImageView().then {
        $0.image = (UIImage(named: "alarm") ?? UIImage(systemName: "bell"))?.withTintColor(.mainColor)
    }
    
    lazy var iconView = UIView().then {
        $0.backgroundColor = .subColor
        $0.layer.cornerRadius = 12
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.font = WFont.subHead3()
        $0.textColor = .gray700
        $0.numberOfLines = 0
    }
    
    lazy var stack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    private func configureUI() {
        
        iconView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        [ iconView, descriptionLabel ].forEach { stack.addArrangedSubview($0) }
        iconView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24))
        }
        
        
    }

}

// MARK: Set Data
extension AlarmTableViewCell {
    
    public func setUpCell(description: String) {
        self.descriptionLabel.text = description
    }
}
