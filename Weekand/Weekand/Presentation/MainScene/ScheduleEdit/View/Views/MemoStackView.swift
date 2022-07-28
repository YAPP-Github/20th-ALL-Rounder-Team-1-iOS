//
//  MemoStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import UIKit

class MemoStackView: UIStackView {
    
    lazy var namelabel = WTextLabel().then {
        $0.textColor = UIColor.gray800
    }
    
    let textView = WTextView()

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
        
        [namelabel, textView].forEach { self.addArrangedSubview($0) }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(150)
        }
    }
    
    init(nameText: String) {
        super.init(frame: CGRect.zero)
        
        self.namelabel.text = nameText
        setupView()
    }
}
