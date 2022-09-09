//
//  PasswordChangeViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxRelay

class PasswordChangeViewController: BaseViewController {
    
    var viewModel: PasswordChangeViewModel?
    private let disposeBag = DisposeBag()
    
    var currentPassword = BehaviorRelay<String>(value: "")
    var newPassword = BehaviorRelay<String>(value: "")
    var checkPassword = BehaviorRelay<String>(value: "")
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.title()
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.text = """
                비밀번호를 변경하여
                안전하게 관리하세요
                """
    }
    
    lazy var currentPasswordField = ProfileEditFieldView(title: "현재 비밀번호", validation: nil).then {
        $0.textField.isSecureTextEntry = true
    }
    
    lazy var newPasswordField = ProfileEditFieldView(title: "새 비밀번호", validation: nil).then {
        $0.textField.isSecureTextEntry = true
    }
    
    lazy var checkPasswordField = ProfileEditFieldView(title: "비밀번호 확인", validation: nil).then {
        $0.textField.isSecureTextEntry = true
    }
    
    lazy var validationLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .wred
        $0.text = "비밀번호가 일치하지 않습니다"
        $0.isHidden = true
    }
    
    lazy var confirmButton = WBottmButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .backgroundColor
        
        self.stackView.spacing = 24
        self.stackView.isLayoutMarginsRelativeArrangement = true
        self.stackView.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 64, right: 24)
    }
    
    private func configureUI() {
        
        checkPasswordField.addSubview(validationLabel)
        checkPasswordField.titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        validationLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(checkPasswordField.titleLabel.snp.height)
            make.centerY.equalTo(checkPasswordField.titleLabel.snp.centerY)
        }
        
        [titleLabel, currentPasswordField, newPasswordField, checkPasswordField].forEach {
            self.stackView.addArrangedSubview($0)
        }
        stackView.setCustomSpacing(40, after: titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
        }
        
        self.view.addSubview(confirmButton)
        confirmButton.disable(string: "완료")
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }

    }
    
    private func bindViewModel() {
        
        currentPasswordField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: currentPassword)
            .disposed(by: disposeBag)
        
        newPasswordField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: newPassword)
            .disposed(by: disposeBag)
        
        checkPasswordField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: checkPassword)
            .disposed(by: disposeBag)
        
        let input = PasswordChangeViewModel.Input(
            currentPassword: currentPassword.asObservable(),
            newPassword: newPassword.asObservable(),
            checkPassword: checkPassword.asObservable(),
            didConfirmButtonTap: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.passwordInvalid.subscribe(onNext: { _ in
            self.passwordInvalidAction()
        }).disposed(by: disposeBag)
        
        output?.passwordIdentical.subscribe(onNext: { isIdentical in
            self.passwordIdenticalAction(isIdentical: isIdentical)
        }).disposed(by: disposeBag)
        
        output?.message.subscribe(onNext: { message in
            self.showToast(message: message)
        }).disposed(by: disposeBag)
    }
}

extension PasswordChangeViewController {
    
    func passwordInvalidAction() {
        showToast(message: "비밀번호가 일치하지 않습니다.")
    }
    
    func passwordIdenticalAction(isIdentical: Bool) {
        self.validationLabel.isHidden = isIdentical
        
        switchConfirmButtonState(isIdentical: isIdentical)
    }
    
    func switchConfirmButtonState(isIdentical: Bool) {
        
        var isFieldsFilled = true
        [currentPasswordField, newPasswordField, checkPasswordField].forEach {
            if ($0.textField.text ?? "").isEmpty { isFieldsFilled = false }
        }
        
        if isFieldsFilled && isIdentical {
            confirmButton.enable(string: "완료")
        } else {
            confirmButton.disable(string: "완료")
        }
    }
}
