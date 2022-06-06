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

    lazy var informationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    lazy var informlabel = WTextLabel().then {
        $0.textColor = UIColor.gray500
    }
    
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
    
    func setNameLabelText(string: String) {
        namelabel.text = string
    }
    
    func setInformlabelText(string: String) {
        informlabel.isHidden = false
        informlabel.text = string
    }
    
    func setPlaceholderText(string: String) {
        buttonTextField.textField.placeholder = string
    }
    
    func setButtonText(string: String) {
        buttonTextField.button.setTitle(string, for: .normal, font: WFont.body2())
    }
    
    // 개선 필요
    func hideTextFieldButton() {
        buttonTextField.button.isHidden = true
    }
    
    func informInvaildMessage(string: String) {
        informlabel.isHidden = false
        informlabel.textColor = .wred
        informlabel.text = string
    }
    
    func informVaildMessage(string: String) {
        informlabel.isHidden = false
        informlabel.textColor = .wblue
        informlabel.text = string
    }
}
