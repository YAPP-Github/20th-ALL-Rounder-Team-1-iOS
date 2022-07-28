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
import RxCocoa

class SignInViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel?
    
    lazy var titleLabel = WTitleLabel().then {
        $0.setText(string: """
                            반가워요!
                            함께 일정 관리해요 :)
                           """)
    }
    
    let spacerView = UIView()
    
    lazy var emailField = WTextField(placeHolder: "이메일을 입력해주세요")
    lazy var passwordField = WTextField(placeHolder: "비밀번호를 입력해주세요").then {
        $0.isSecureTextEntry = true
    }
    
    lazy var textFieldStack = UIStackView().then {
        $0.addArrangedSubview(emailField)
        $0.addArrangedSubview(passwordField)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    lazy var autoSignCheckBox = WCheckBox()
    lazy var autoSignLabel = WTextLabel().then {
        $0.textColor = .gray900
        $0.text = "자동로그인"
    }
    lazy var signUpLink = WTextButton(title: "비밀번호 찾기")
    lazy var optionView = UIView().then {
        $0.addSubview(autoSignCheckBox)
        $0.addSubview(autoSignLabel)
        $0.addSubview(signUpLink)

        autoSignCheckBox.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        autoSignLabel.snp.makeConstraints { make in
            make.leading.equalTo(autoSignCheckBox.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview()
        }

        signUpLink.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    lazy var nextButton = WBottmButton(title: "로그인")
    
    let isCheckedAutoSign = BehaviorRelay<Bool>(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        stackView.spacing = 10
        
        [titleLabel, spacerView, textFieldStack, optionView].forEach { stackView.addArrangedSubview($0) }
        
        spacerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(22)
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
            passwordFindButtonDidTapEvent: signUpLink.rx.tap.asObservable(),
            nextButtonDidTapEvent: nextButton.rx.tap.asObservable(),
            isSelectAutoSign: isCheckedAutoSign
        )
        
        autoSignCheckBox.rx.tap.subscribe(onNext: {
            self.autoSignCheckBox.isChecked = !self.autoSignCheckBox.isChecked
            self.isCheckedAutoSign.accept(self.autoSignCheckBox.isChecked)
        }).disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonEnable.drive(onNext: { [weak self] state in
            if state {
                self?.nextButton.enable(string: "다음")
            } else {
                self?.nextButton.disable(string: "로그인")
            }
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
