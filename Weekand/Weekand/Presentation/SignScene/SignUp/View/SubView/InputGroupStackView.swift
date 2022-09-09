//
//  InputGroupStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/24.
//

import UIKit
import Then
import SnapKit

class InputGroupStackView: UIStackView {
    
    enum InformType {
        case normal
        case vaild
        case invaild
        
        var textColor: UIColor {
            switch self {
            case .normal:
                return .gray500
            case .vaild:
                return .wblue
            case .invaild:
                return .wred 
            }
        }
    }

    lazy var informationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    let informlabel = WTextLabel()
    
    let buttonTextField = WButtonTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 10
        
        [namelabel, informlabel].forEach { informationStackView.addArrangedSubview($0) }
        [informationStackView, buttonTextField].forEach { self.addArrangedSubview($0) }
        
        namelabel.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
    }

}

extension InputGroupStackView {
    func setNameLabelText(string: String) {
        namelabel.text = string
    }
    
    func setInformlabelText(string: String, informType: InformType) {
        informlabel.isHidden = false
        informlabel.text = string
        informlabel.textColor = informType.textColor
    }
    
    func setPlaceholderText(string: String) {
        buttonTextField.textField.placeholder = string
    }
    
    func setButtonText(string: String) {
        buttonTextField.button.setTitle(string, for: .normal, font: WFont.body2())
    }
    
    func disableButton(title: String) {
        buttonTextField.button.isEnabled = false
        buttonTextField.button.setButtonColor(title, foregroundColor: .white, backgroundColor: .gray300)
    }
    
    func enableButton(title: String) {
        buttonTextField.button.isEnabled = true
        buttonTextField.button.setButtonColor(title, foregroundColor: .white, backgroundColor: .mainColor)
    }
    
    func disableTextField() {
        buttonTextField.textField.textColor = .gray500
        buttonTextField.textField.isEnabled = false
    }

    func hideTextFieldButton() {
        buttonTextField.button.isHidden = true
    }
    
    func hideInformlabel() {
        informlabel.isHidden = true
    }
    
    func setSecureTextEntry() {
        buttonTextField.textField.isSecureTextEntry = true
    }
    
}
