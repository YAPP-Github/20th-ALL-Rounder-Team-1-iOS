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
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel?
    
    lazy var welcomeLabel = WTitleLabel().then {
        $0.setText(string: "Weekand와\n함께 시작해요!")
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("다음", for: .normal)
        $0.enable(string: "다음")
    }
    
    lazy var emailStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "이메일")
        $0.setPlaceholderText(string: "이메일을 입력해주세요")
        $0.setButtonText(string: "인증")
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
 
        view.backgroundColor = .white
        stackView.spacing = 30
        configureUI()
        bindViewModel()
    }
    
    func configureUI() {
        [welcomeLabel, emailStackView, authenticationNumberStackView, nickNameStackView, passwordStackView, passwordCheckStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            // top 임시값 세팅
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 20)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let input = SignUpViewModel.Input(
            emailTextFieldDidEditEvent: emailStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            emailButtonDidTapEvent: emailStackView.buttonTextField.button.rx.tap.asObservable(),
            authenticationNumberTextFieldDidEditEvent: authenticationNumberStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            authenticationNumberButtonDidTapEvent: authenticationNumberStackView.buttonTextField.button.rx.tap.asObservable(),
            nickNameTextFieldDidEditEvent: nickNameStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            nickNameButtonDidTapEvent: nickNameStackView.buttonTextField.button.rx.tap.asObservable(),
            passwordTextFieldDidEditEvent: passwordStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            passwordCheckTextFieldDidEditEvent: passwordCheckStackView.buttonTextField.textField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        emailStackView.buttonTextField.button.rx.tap.bind { [weak self] in
            output.vaildEmail.drive(onNext: { [weak self] isVaild in
                if isVaild {
                    self?.emailStackView.informInvaildMessage(string: "")
                    // 버튼 비활성화 코드
                    self?.emailStackView.buttonTextField.button.isEnabled = false
                } else {
                    // 임시
                    self?.emailStackView.informInvaildMessage(string: "올바른 형식으로 입력해주세요")
                }
            }).dispose()
        }.disposed(by: disposeBag)
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
