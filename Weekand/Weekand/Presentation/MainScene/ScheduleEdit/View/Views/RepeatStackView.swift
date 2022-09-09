//
//  RepeatStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/22.
//

import UIKit

class RepeatStackView: UIStackView {

    lazy var titleLabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
        $0.text = "반복"
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

    lazy var nameLabel = WTextLabel().then {
        $0.backgroundColor?.withAlphaComponent(0)
        $0.font = WFont.body1()
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
        
        [titleLabel, backgroundView].forEach { self.addArrangedSubview($0) }

        backgroundView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-7.5)
            make.height.equalTo(52)
        }
        stackView.addArrangedSubview(nameLabel)
    }

}

extension RepeatStackView {
    func setRepeatText(_ text: String) {
        nameLabel.text = text
    }
}
