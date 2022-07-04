//
//  MainTableViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit
import SnapKit
import Then

/// 메인화면 일정 리스트 TableView에 쓰이는 Cell
class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    // MARK: 상단 (카테고리 색상 원 + 일정 이름)
    lazy var nameLabel = WCategoryTitleLabel()
    
    // MARK: 하단 (아이콘 & 시작~종료 시간 + 이모지)
    lazy var timeLineLabel = WStatusTimeLabel()
    lazy var emojiView = WEmojiView()
    
    lazy var bottomStack = UIStackView().then {
        $0.addArrangedSubview(timeLineLabel)
        $0.addArrangedSubview(emojiView)
        
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    lazy var cellStack = UIStackView().then {
        
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(bottomStack)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 9
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
        configureUI()
    }
    
    private func setUp() {
        self.selectionStyle = .none
    }
    
    private func configureUI() {
        
        self.addSubview(cellStack)
        
        cellStack.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 31, bottom: 15, right: 24))
        }
        
    }

}

// MARK: Data Injection
extension MainTableViewCell {
    
    public func setUpCell(color: UIColor, title: String, status: StatusIcon, time: String, emojiNumber: Int, emojiOrder: [Emoji]) {
        
        self.nameLabel.editValue(color: color, title: title)
        self.timeLineLabel.configureValue(status: status, title: time)
        self.emojiView.numberLabel.text = String(emojiNumber)
        self.emojiView.setEmoji(emojiOrder: emojiOrder)
    }
    
    // TODO: API 확정되면 수정
    public func setUpCell(_ model: ScehduleMain) {
        
    }

}

// MARK: Touch Event
extension MainTableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
