//
//  FilterCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    static let cellIdentifier = "FilterCell"
    
    lazy var cellStack = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
    }
    
    lazy var filterNameLabel = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        contentView.addSubview(cellStack)
        cellStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(54)
        }
        cellStack.addArrangedSubview(filterNameLabel)
    }
    
    private func setupView() {
        let backgoundView = UIView()
        backgoundView.backgroundColor = .gray100
        self.selectedBackgroundView = backgoundView
    }

    public func configure(text: String) {
        self.filterNameLabel.text = text
    }
}
