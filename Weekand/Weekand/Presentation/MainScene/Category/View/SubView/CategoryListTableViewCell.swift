//
//  CategoryListTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/07.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    static let cellIdentifier = "CategoryListCell"
    
    lazy var cellStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }
    
    lazy var colorView = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    lazy var contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    lazy var openTypeLabel = UILabel().then {
        $0.font = WFont.body3()
        $0.textColor = .gray500
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.subHead2()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
        setupView()
    }
    
    private func setupView() { }
    
    private func configureUI() {
        
        self.addSubview(cellStack)
        
        cellStack.addArrangedSubview(colorView)
        cellStack.addArrangedSubview(contentStack)

        cellStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(69)
        }
        
        colorView.snp.makeConstraints { make in
            make.width.height.equalTo(cellStack.snp.width).multipliedBy(1/10.4)
            make.centerY.equalTo(cellStack.snp.centerY)
        }
        
        contentStack.addArrangedSubview(openTypeLabel)
        contentStack.addArrangedSubview(nameLabel)
    }
    
    public func configure(color: UIColor, openType: CategoryOpenType, name: String) {
        colorView.backgroundColor = color
        openTypeLabel.text = openType.description
        nameLabel.text = name
    }
    
}
