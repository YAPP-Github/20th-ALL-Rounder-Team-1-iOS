//
//  WTextFieldStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class WTextFieldStackView: UIStackView {
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    let textField = WTextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
        
        [namelabel, textField].forEach { self.addArrangedSubview($0) }
    }
    
    init(fieldPlaceholder: String, nameText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        self.textField.attributedPlaceholder = NSAttributedString(string: fieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!])
        setupView()
    }
}
