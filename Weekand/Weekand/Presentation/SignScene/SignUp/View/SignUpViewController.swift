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
    
    lazy var cancelButton = UIBarButtonItem(title: "취소", style: .done, target: nil, action: nil).then {
        $0.tintColor = .gray700
    }
    
    lazy var welcomeLabel = WTitleLabel().then {
        $0.setText(string: "Weekand와\n함께 시작해요!")
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("다음", for: .normal)
        $0.disable(string: "다음")
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
    }
    
    lazy var nickNameStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "닉네임")
        $0.setPlaceholderText(string: "닉네임을 입력해주세요")
        $0.setButtonText(string: "중복확인")
    }
    
    lazy var passwordStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호")
        $0.setInformlabelText(string: "숫자, 영어 조합 8자리 이상", informType: .normal)
        $0.setPlaceholderText(string: "비밀번호를 입력해주세요")
        $0.setSecureTextEntry()
        $0.hideTextFieldButton()
    }
    
    lazy var passwordCheckStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호 확인")
        $0.setPlaceholderText(string: "비밀번호를 확인해주세요")
        $0.setSecureTextEntry()
        $0.hideTextFieldButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = cancelButton
        stackView.spacing = 25
    }
    
    private func configureUI() {
        [welcomeLabel, emailStackView, authenticationNumberStackView, nickNameStackView, passwordStackView, passwordCheckStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(22)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
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
        
        let input = SignUpViewModel.Input(
            emailTextFieldDidEditEvent: emailStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            emailButtonDidTapEvent: emailStackView.buttonTextField.button.rx.tap.asObservable(),
            authNumberTextFieldDidEditEvent: authenticationNumberStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            authNumberButtonDidTapEvent: authenticationNumberStackView.buttonTextField.button.rx.tap.asObservable(),
            nickNameTextFieldDidEditEvent: nickNameStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            nickNameButtonDidTapEvent: nickNameStackView.buttonTextField.button.rx.tap.asObservable(),
            passwordTextFieldDidEditEvent: passwordStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            passwordTextFieldDidEndEditEvent: passwordStackView.buttonTextField.textField.rx.controlEvent([.editingChanged]).asObservable(),
            passwordCheckTextFieldDidEditEvent: passwordCheckStackView.buttonTextField.textField.rx.text.orEmpty.asObservable(),
            passwordCheckTextFieldDidEndEditEvent: passwordCheckStackView.buttonTextField.textField.rx.controlEvent([.editingChanged]).asObservable(),
            nextButtonDidTapEvent: confirmButton.rx.tap.asObservable(),
            cancelButtonDidTapEvent: cancelButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        bindOutput(output)
    }
    
    private func bindOutput(_ output: SignUpViewModel.Output) {
        output.vaildEmail.drive(onNext: { [weak self] isVaild in
            if isVaild {
                self?.emailStackView.hideInformlabel()
            } else {
                self?.emailStackView.setInformlabelText(string: "올바른 형식으로 입력해주세요", informType: .invaild)
            }
        }).disposed(by: disposeBag)
        
        output.checkAuthenticationNumber.drive(onNext: { [weak self] isCheck in
            if isCheck {
                self?.authenticationNumberStackView.hideInformlabel()
                self?.authenticationNumberStackView.disableButton(title: "확인완료")
                self?.emailStackView.disableButton(title: "인증완료")
                self?.emailStackView.disableTextField()
                self?.authenticationNumberStackView.disableTextField()
            } else {
                self?.authenticationNumberStackView.setInformlabelText(string: "잘못된 인증번호입니다", informType: .invaild)
            }
        }).disposed(by: disposeBag)
        
        output.checkNickName.drive(onNext: { [weak self] isCheck in
            if isCheck {
                self?.nickNameStackView.setInformlabelText(string: "사용가능한 닉네임입니다", informType: .vaild)
                self?.nickNameStackView.disableButton(title: "중복확인")
            } else {
                self?.nickNameStackView.setInformlabelText(string: "중복된 닉네임입니다", informType: .invaild)
            }
        }).disposed(by: disposeBag)
        
        nickNameStackView.buttonTextField.textField.rx.controlEvent([.editingChanged]).subscribe(onNext: { [weak self] in
            self?.nickNameStackView.enableButton(title: "중복확인")
            self?.nickNameStackView.hideInformlabel()
        }).disposed(by: disposeBag)
        
        output.vaildPassword.drive(onNext: { [weak self] isVaild in
            if isVaild {
                self?.passwordStackView.setInformlabelText(string: "숫자, 영어 조합 8자리 이상", informType: .normal)
            } else {
                self?.passwordStackView.setInformlabelText(string: "숫자, 영어 조합 8자리 이상 입력해주세요", informType: .invaild)
            }
        }).disposed(by: disposeBag)
        
        output.accordPassword.drive(onNext: { [weak self] isAccord in
            if isAccord {
                self?.passwordCheckStackView.hideInformlabel()
            } else {
                self?.passwordCheckStackView.setInformlabelText(string: "비밀번호가 일치하지 않습니다", informType: .invaild)
            }
        }).disposed(by: disposeBag)
        
        output.nextButtonEnable.drive(onNext: { [weak self] state in
            if state {
                self?.confirmButton.enable(string: "다음")
            } else {
                self?.confirmButton.disable(string: "다음")
            }
        }).disposed(by: disposeBag)
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
