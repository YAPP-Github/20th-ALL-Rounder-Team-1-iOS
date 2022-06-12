//
//  WCheckBox.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit

class WCheckBox: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    private func setupView() {
        self.setImage(UIImage(systemName: "checkmark.square.fill")!.withTintColor(.lightGray!), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.square.fill")!.withTintColor(.mainColor), for: .selected)
        
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitleColor(.darkGray, for: .selected)
        
        self.titleLabel?.font = WFont.body2()
    }
    
    init(title: String, isChecked: Bool) {
        super.init(frame: CGRect.zero)
        
        setupView()
        
        self.isSelected = isChecked
        
        
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
    }

}
