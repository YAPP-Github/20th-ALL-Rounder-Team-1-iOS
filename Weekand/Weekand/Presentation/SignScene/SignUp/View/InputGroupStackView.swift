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
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.font = UIFont(name: "PretendardVariable-Regular", size: defaultFontSize)
        $0.textColor = UIColor.wgray
    }
    
    lazy var informlabel = WTextLabel().then {
        $0.font = UIFont(name: "PretendardVariable-Regular", size: defaultFontSize)
        $0.textColor = UIColor.worange
        // $0.isHidden = true
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
        informationStackView.spacing = 5
        
        [namelabel, informlabel].forEach { informationStackView.addArrangedSubview($0) }
        [informationStackView, buttonTextField].forEach { self.addArrangedSubview($0) }
    }
    
    func setNameLabelText(string: String) {
        namelabel.text = string
    }
    
    func setInformlabelText(string: String) {
        informlabel.text = string
    }
    
    func setPlaceholderText(string: String) {
        buttonTextField.textField.placeholder = string
    }
    
    func setButtonText(string: String) {
        buttonTextField.button.setTitle(string, for: .normal)
    }
    
    // 개선 필요
    func hideTextFieldButton() {
        buttonTextField.button.isHidden = true
    }
}
