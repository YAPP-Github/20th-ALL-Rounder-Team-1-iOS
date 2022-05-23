//
//  SignUpViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit
import Then
import SnapKit
import SwiftUI

class SignUpViewController: UIViewController {
    
    lazy var button = WDefaultButton().then {
        $0.setTitle("확인", for: .normal)
    }
    
    lazy var emailTextField = WButtonTextField().then {
        $0.textField.placeholder = "이메일"
        $0.button.setTitle("인증", for: .normal)
    }
    
    lazy var authenticationNumberTextField = WButtonTextField().then {
        $0.textField.placeholder = "인증번호"
        $0.button.setTitle("확인", for: .normal)
    }
    
    lazy var nickNameTextField = WButtonTextField().then {
        $0.textField.placeholder = "닉네임"
        $0.button.setTitle("중복확인", for: .normal)
    }
    
    lazy var passwordTextField = WTextField().then {
        $0.placeholder = "비밀번호"
    }
    
    lazy var passwordCheckTextField = WTextField().then {
        $0.placeholder = "비밀번호 확인"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(authenticationNumberTextField)
        self.view.addSubview(nickNameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordCheckTextField)
        self.view.addSubview(button)
        setUpConstraint()
    }
    
    func setUpConstraint() {
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(2.2)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.31)
            make.height.equalTo(view.snp.width).multipliedBy(1/6.2)
        }
        
        authenticationNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.31)
            make.height.equalTo(view.snp.width).multipliedBy(1/6.2)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(authenticationNumberTextField.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.31)
            make.height.equalTo(view.snp.width).multipliedBy(1/6.2)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.31)
            make.height.equalTo(view.snp.width).multipliedBy(1/6.2)
        }
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.31)
            make.height.equalTo(view.snp.width).multipliedBy(1/6.2)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(1/4.4)
            make.width.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG

struct SignUpViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpViewController().showPreview(.iPhone8)
        }
    }
}
#endif
