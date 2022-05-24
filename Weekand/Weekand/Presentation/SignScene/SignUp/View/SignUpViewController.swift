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
        $0.setText(string: "Weekand와\n함께 시작해요!")
    }
    
    lazy var button = WBottmButton().then {
        $0.setTitle("확인", for: .normal)
    }
    
    lazy var emailStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "이메일")
        $0.setPlaceholderText(string: "이메일을 입력해주세요")
        $0.setButtonText(string: "인증")
        $0.informInvaildMessage(string: "올바른 형식으로 입력해주세요")
    }
    
    lazy var authenticationNumberStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "인증번호")
        $0.setPlaceholderText(string: "인증번호를 입력해주세요")
        $0.setButtonText(string: "확인")
        $0.informInvaildMessage(string: "잘못된 인증번호입니다")
    }
    
    lazy var nickNameStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "닉네임")
        $0.setPlaceholderText(string: "닉네임을 입력해주세요")
        $0.setButtonText(string: "중복확인")
        // $0.informInvaildMessage(string: "중복된 닉네임입니다")
        $0.informVaildMessage(string: "사용가능한 닉네임입니다")
    }
    
    lazy var passwordStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호")
        $0.setInformlabelText(string: "숫자, 영어 조합 8자리 이상")
        $0.setPlaceholderText(string: "비밀번호를 입력해주세요")
        // $0.informWarningMessage(string: "숫자, 영어 조합 8자리 이상 입력해주세요")
        $0.hideTextFieldButton()
    }
    
    lazy var passwordCheckStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호 확인")
        $0.setPlaceholderText(string: "비밀번호를 확인해주세요")
        $0.informInvaildMessage(string: "비밀번호가 일치하지 않습니다")
        $0.hideTextFieldButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        stackView.spacing = 30
        [welcomeLabel, emailStackView, authenticationNumberStackView, nickNameStackView, passwordStackView, passwordCheckStackView].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(button)
        setUpConstraint()
    }
    
    func setUpConstraint() {
        stackView.snp.makeConstraints { make in
            // top 임시값 세팅
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 20)
            make.trailing.leading.equalToSuperview().inset(20)
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
