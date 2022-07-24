//
//  CategorySheetTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import UIKit

class CategorySheetTableViewCell: UITableViewCell {

    static let cellIdentifier = "CategorySheetListCell"
    
    lazy var cellStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }
    
    lazy var colorView = UIView().then {
        $0.layer.cornerRadius = 5
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.body1()
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
        cellStack.addArrangedSubview(nameLabel)

        cellStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(50)
        }
        
        colorView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.centerY.equalTo(cellStack.snp.centerY)
        }
    }
    
    public func configure(color: UIColor, name: String) {
        colorView.backgroundColor = color
        nameLabel.text = name
    }
    
}
