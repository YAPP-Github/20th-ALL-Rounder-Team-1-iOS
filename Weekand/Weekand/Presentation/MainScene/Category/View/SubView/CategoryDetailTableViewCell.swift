//
//  CategoryDetailTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit
import Then

class CategoryDetailTableViewCell: UITableViewCell {

    static let cellIdentifier = "CategoryDetailCell"
    
    lazy var scheduelNameLabel = WCategoryTitleLabel()
    
    let dateLabel = DateTimeLabel()
    let timeLabel = DateTimeLabel()
    lazy var repeatLabel = WTextLabel().then {
        $0.textColor = .gray500
    }
    
    lazy var bottomStack = UIStackView().then {
        $0.addArrangedSubview(timeLabel)
        $0.addArrangedSubview(repeatLabel)
        
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    lazy var cellStack = UIStackView().then {
        $0.addArrangedSubview(scheduelNameLabel)
        $0.addArrangedSubview(dateLabel)
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
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24))
        }
    }
    
    private func setupView() { }

    public func configure(color: UIColor, title: String, date: String, time: String, repeatText: String?) {
        self.scheduelNameLabel.editValue(color: color, title: title)
        self.dateLabel.configureValue(type: .date, title: date)
        self.timeLabel.configureValue(type: .time, title: time)
        self.repeatLabel.text = repeatText ?? ""
    }
}
