//
//  WButtonTextField.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit

class WButtonTextField: UIView {
    
    let textField = WTextField()
    let button = WDefaultButton().then {
        
        if #available(iOS 15.0, *) {
            $0.configuration?.background.backgroundColor = .black
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.internalEdgeInset
        } else {
            $0.backgroundColor = UIColor.mainColor
            $0.titleEdgeInsets = UIEdgeInsets.internalEdgeInset
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
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIEdgeInsets.defaultInsetAmount/2)
            make.bottom.equalToSuperview().offset(-UIEdgeInsets.defaultInsetAmount/2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-UIEdgeInsets.defaultInsetAmount/2)
        }
        
    }

}
