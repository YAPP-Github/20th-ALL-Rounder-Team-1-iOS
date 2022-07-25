//
//  ProfileEditFieldStack.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import UIKit
import SnapKit
import Then

class ProfileEditFieldView: UIView {
    
    var maxLength: Int?
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray800
        $0.textAlignment = .left
    }
    
    lazy var validationLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray500
        $0.textAlignment = .right
    }
    
    lazy var labelStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fill
    }
    
    lazy var textField = WTextField()
    
    init(title: String, validation: Int?) {
        super.init(frame: .zero)
        
        setUpView()
        configureUI()
        
        titleLabel.text = title
        if validation == nil {
            validationLabel.isHidden = true
            textField.allowsEditingTextAttributes = false
            textField.tintColor = .clear
        } else {
            maxLength = validation
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        textField.delegate = self
        textField.placeholder = ""
    }
    
    private func configureUI() {
        
        [titleLabel, validationLabel].forEach { labelStack.addArrangedSubview($0) }
        
        [labelStack, textField].forEach { self.addSubview($0) }
        labelStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension ProfileEditFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        guard let limit = maxLength else { return false }
        
        if let input = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(input, "\\b")
            if isBackSpace == -92 {
                updateValidationText(length: text.count-1, limit: limit)
                return true
            }
        }
        
        let length = text.count + (string == "" ? -1 : +1)
        guard length <= limit else { return false }
        updateValidationText(length: length, limit: limit)
        
        return true
    }
    
    func updateValidationText(length: Int, limit: Int) {
        validationLabel.text = "\(length)/\(limit)자"
    }
}
