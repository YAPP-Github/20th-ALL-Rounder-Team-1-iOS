//
//  DropDownStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import DropDown

class DropDownStackView: UIStackView {

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.text = "카테고리"
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 12
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    lazy var colorView = UIView().then {
        $0.backgroundColor = UIColor.mainColor
        $0.layer.cornerRadius = 3
    }

    lazy var label = WTextLabel().then {
        $0.backgroundColor?.withAlphaComponent(0)
        $0.font = WFont.body1()
        $0.text = "내 일정"
    }
    
    let arrowButton = WArrowButton()
    
    lazy var dropDown = DropDown(anchorView: arrowButton).then {
        
        $0.bottomOffset = CGPoint(x: -(UIScreen.main.bounds.size.width * 0.75), y: 55)
        $0.backgroundColor = .white
        $0.selectionBackgroundColor = .gray100
        $0.cornerRadius = 10
        $0.width = UIScreen.main.bounds.size.width * 0.88
        $0.cellHeight = 46
        $0.shadowOpacity = 0.1
        $0.layer.borderColor = UIColor.gray200.cgColor
        $0.layer.borderWidth = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
        
        [namelabel, backgroundView].forEach { self.addArrangedSubview($0) }

        backgroundView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-7.5)
            make.height.equalTo(52)
        }
        
        stackView.addArrangedSubview(colorView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(backgroundView.snp.width).multipliedBy(1/7.4)
        }
        
        colorView.snp.makeConstraints { make in
            make.height.width.equalTo(10)
        }
    }

}
