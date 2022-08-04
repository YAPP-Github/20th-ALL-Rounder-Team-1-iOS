//
//  WButtonTextField.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit

class WButtonTextField: UIView {
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .gray200
        $0.layer.cornerRadius = 12
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    lazy var textField = WTextField().then {
        $0.backgroundColor?.withAlphaComponent(0)
    }
    
    let button = WDefaultButton(title: "", font: WFont.body2()).then {
        
        if #available(iOS 15.0, *) {
            $0.configuration?.background.cornerRadius = 8
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.internalEdgeInset
        } else {
            $0.layer.cornerRadius = 8
            $0.contentEdgeInsets = UIEdgeInsets.internalEdgeInset
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-7.5)
        }
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(backgroundView.snp.width).multipliedBy(1/4.2)
        }
        
    }
    
    init(fieldPlaceholder: String, buttonTitle: String) {
        super.init(frame: CGRect.zero)
        
        self.textField.attributedPlaceholder = NSAttributedString(string: fieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!])
        
        self.button.setTitle(buttonTitle, for: .normal)
    }

}
