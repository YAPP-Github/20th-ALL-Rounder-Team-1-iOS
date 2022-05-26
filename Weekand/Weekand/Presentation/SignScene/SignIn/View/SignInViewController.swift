//
//  SignInViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit
import SnapKit
import Then

class SignInViewController: UIViewController {
    
    lazy var titleLabel = UILabel().then {
        $0.text = """
                    반가워요!
                    함께 일정 관리해요 :)
                  """
        $0.font = UIFont(name: "PretendardVariable-Bold", size: defaultFontSize*1.75)
        $0.numberOfLines = 0
    }
    
    lazy var emailField = WTextField(placeHolder: "이메일을 입력해주세요")
    lazy var passwordField = WTextField(placeHolder: "비밀번호를 입력해주세요")
    
    lazy var textFieldStack = UIStackView().then {
        $0.addArrangedSubview(emailField)
        $0.addArrangedSubview(passwordField)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    lazy var autoSignCheckBox = WCheckBox(title: "자동 로그인", isChecked: false)
    lazy var signUpLink = WTextButton(title: "회원가입")
    lazy var optionView = UIView().then {
        $0.addSubview(autoSignCheckBox)
        $0.addSubview(signUpLink)

        autoSignCheckBox.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }

        signUpLink.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    lazy var nextButton = WBottmButton(title: "로그인")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview().dividedBy(2)
        }
        
        self.view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview()
        }

        self.view.addSubview(optionView)
        optionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.top.equalTo(textFieldStack.snp.bottom).offset(10)
        }

        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    
}


import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct SignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SignInViewController().showPreview(.iPhone8)
            SignInViewController().showPreview(.iPhone12Mini)
        }
    }
}
#endif
