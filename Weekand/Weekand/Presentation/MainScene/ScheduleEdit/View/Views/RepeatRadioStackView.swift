//
//  RepeatRadioStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import UIKit

class RepeatRadioStackView: UIStackView {

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray900
        $0.font = WFont.subHead2()
        $0.text = "반복종료"
    }
    
    let tableView = UITableView()
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    lazy var calendarContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    let calendarView = WCalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = 10
        
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        
        self.addArrangedSubview(namelabel)
        self.addArrangedSubview(tableView)
        self.addArrangedSubview(dividerLine)
        self.addArrangedSubview(calendarContainerView)
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        calendarContainerView.addSubview(calendarView)
        
        calendarContainerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(350)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
