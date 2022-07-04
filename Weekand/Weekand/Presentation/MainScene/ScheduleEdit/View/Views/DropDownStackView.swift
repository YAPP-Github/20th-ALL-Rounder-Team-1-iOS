//
//  DropDownStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit

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
    }
    
    lazy var label = WTextLabel().then {
        $0.backgroundColor?.withAlphaComponent(0)
        $0.text = "todo"
    }
    
    let button = WArrowButton()

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
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(backgroundView.snp.width).multipliedBy(1/7.4)
        }
        
    }

}
