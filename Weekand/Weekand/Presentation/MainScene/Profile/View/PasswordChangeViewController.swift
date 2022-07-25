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

class PasswordChangeViewController: BaseViewController {
    
    var viewModel: PasswordChangeViewModel?
    private let disposeBag = DisposeBag()
    
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
    
    lazy var validationField = UILabel().then {
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
        
        checkPasswordField.addSubview(validationField)
        checkPasswordField.titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        validationField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(checkPasswordField.titleLabel.snp.height)
            make.centerY.equalTo(checkPasswordField.titleLabel.snp.centerY)
        }
        
        [titleLabel, currentPasswordField, newPasswordField, checkPasswordField].forEach {
            self.stackView.addArrangedSubview($0)
        }
        stackView.setCustomSpacing(40, after: titleLabel)
        
        self.contentView.addSubview(stackView)
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
        
    }
}
