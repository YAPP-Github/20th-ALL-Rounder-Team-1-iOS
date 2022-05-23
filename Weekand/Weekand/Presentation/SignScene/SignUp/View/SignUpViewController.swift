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

class SignUpViewController: BaseViewController {
    
    lazy var welcomeLabel = WTitleLabel().then {
        $0.text = "Weekand와\n함께 시작해요!"
    }
    
    lazy var button = WBottmButton().then {
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
 
        stackView.spacing = 30
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(authenticationNumberTextField)
        stackView.addArrangedSubview(nickNameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCheckTextField)
        view.addSubview(button)
        setUpConstraint()
    }
    
    func setUpConstraint() {
        stackView.snp.makeConstraints { make in
            // TODO: top 임시값 세팅
            make.top.equalToSuperview().inset(30)
            make.right.left.equalToSuperview().inset(10)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
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
