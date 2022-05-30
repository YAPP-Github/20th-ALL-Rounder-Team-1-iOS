//
//  MainTableViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit
import SnapKit
import Then

class MainTableViewCell: UITableViewCell {
    
    // MARK: 상단 (카테고리 색상 원 + 일정 이름)
    lazy var nameLabel = WCategoryTitleLabel()
    
    // MARK: 하단 (아이콘 & 시작~종료 시간 + 이모지)
    lazy var timeLineLabel = WStatusTimeLabel()
    
    // TODO: Create & Add Emoji View
    
    lazy var cellStack = UIStackView().then {
        
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(timeLineLabel)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5.25
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        
        self.addSubview(cellStack)
        
        cellStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
    }
    
    public func configureCell(color: UIColor, title: String, status: StatusIcon, time: String) {
        
        self.nameLabel.editValue(color: color, title: title)
        self.timeLineLabel.editValue(status: status, title: time)
    }

}

// MARK: Touch Event
extension MainTableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainCellPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cell = MainTableViewCell()
            cell.configureCell(color: .red, title: "This is Title", status: .completed, time: "00:00 - 00:00")
            
            return cell
        }.previewLayout(.sizeThatFits)
    }
}
#endif
