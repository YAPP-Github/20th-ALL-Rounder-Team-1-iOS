//
//  CategoryDetailTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit
import Then

class CategoryDetailTableViewCell: UITableViewCell {

    static let cellIdentifier = "CategoryCell"
    
    lazy var scheduelNameLabel = WCategoryTitleLabel()
    
    lazy var startDateLabel = WStatusTimeLabel()
    lazy var endDateLabel = WStatusTimeLabel()
    lazy var repeatLabel = WTextLabel().then {
        $0.textColor = .gray500
    }
    
    lazy var bottomStack = UIStackView().then {
        $0.addArrangedSubview(endDateLabel)
        $0.addArrangedSubview(repeatLabel)
        
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    lazy var cellStack = UIStackView().then {
        $0.addArrangedSubview(scheduelNameLabel)
        $0.addArrangedSubview(startDateLabel)
        $0.addArrangedSubview(bottomStack)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
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
    
    private func configureUI() {
        self.addSubview(cellStack)
        cellStack.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 24, bottom: 19, right: 24))
        }
    }
    
    private func setupView() { }

    public func configure(color: UIColor, title: String, startDate: String, endDate: String, repeatText: String?) {
        self.scheduelNameLabel.editValue(color: color, title: title)
        self.startDateLabel.configureValue(status: .start, title: startDate)
        self.endDateLabel.configureValue(status: .end, title: endDate)
        if let repeatText = repeatText {
            self.repeatLabel.text = repeatText
        } else {
            self.repeatLabel.text = ""
        }
    }
}
