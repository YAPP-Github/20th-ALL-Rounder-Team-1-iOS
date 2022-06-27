//
//  ColorStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit

class ColorStackView: UIStackView {

    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    lazy var colorView = UIButton().then {
        $0.layer.cornerRadius = 5
    }
    
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
        self.alignment = .leading
        self.spacing = 10
        
        [namelabel, colorView].forEach { self.addArrangedSubview($0) }
        
        colorView.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
    }
    
    init(nameText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        setupView()
    }
    
    func setColor(_ color: UIColor) {
        colorView.backgroundColor = color
    }

}
