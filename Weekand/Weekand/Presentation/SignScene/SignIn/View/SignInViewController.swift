//
//  SignInViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SignInViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel?
    
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
    lazy var signUpLink = WTextButton(title: "비밀번호 찾기")
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
        bindViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
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
    
    private func bindViewModel() {
        guard let viewModel = self.viewModel else {
            return
        }

        let input = SignInViewModel.Input(
            emailTextFieldDidEditEvent: emailField.rx.text.orEmpty.asObservable(),
            passwordTextFieldDidEditEvent: passwordField.rx.text.orEmpty.asObservable(),
            autoSignButtonDidTapEvent: autoSignCheckBox.rx.tap.asObservable(),
            nextButtonDidTapEvent: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonEnable.drive(onNext: { [weak self] state in
            if state {
                self?.nextButton.enable(string: "다음")
            } else {
                self?.nextButton.disable(string: "로그인")
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(onNext: { [weak self] in
            output.checkEmailPassword.drive(onNext: { [weak self] isCheck in
                if isCheck {
                    print("다음")
                } else {
                    print("alert")
                }
            }).dispose()
        }).disposed(by: disposeBag)
        
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
