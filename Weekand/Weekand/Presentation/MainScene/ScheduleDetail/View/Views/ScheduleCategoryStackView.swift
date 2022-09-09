//
//  ScheduleCategoryStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import UIKit

class ScheduleCategoryStackView: UIStackView {
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 10
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

    lazy var nameLabel = WTextLabel().then {
        $0.backgroundColor?.withAlphaComponent(0)
        $0.font = WFont.body1()
        $0.text = "내 일정"
    }
    
    let arrowButton = WArrowButton()

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
        
        [backgroundView].forEach { self.addArrangedSubview($0) }

        backgroundView.addSubview(stackView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        stackView.addArrangedSubview(colorView)
        stackView.addArrangedSubview(nameLabel)
        
        colorView.snp.makeConstraints { make in
            make.height.width.equalTo(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }

}

extension ScheduleCategoryStackView {
    func setCategory(_ category: Category) {
        colorView.backgroundColor = UIColor(hex: category.color)!
        nameLabel.text = category.name
    }
}
