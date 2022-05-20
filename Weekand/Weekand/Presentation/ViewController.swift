//
//  ViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/05.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    
    lazy var textField = WTextField().then {
        $0.placeholder = "이메일을 입력해주세요"
    }
    
    lazy var button = WDefaultButton().then {
        $0.setTitle("확인", for: .normal)
    }
    
    lazy var buttonField = WButtonTextField().then {
        $0.textField.placeholder = "이메일"
        $0.button.setTitle("인증", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(1.5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
        }
        
        self.view.addSubview(buttonField)
        buttonField.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
        }
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(buttonField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
        }

    }
}
