//
//  WCheckBox.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit

class WCheckBox: UIButton {
    
    let checkedImage = UIImage(named: "CheckBox")!.withTintColor(.gray300)
    let uncheckedImage = UIImage(named: "CheckBox")!.withTintColor(.mainColor)

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(isChecked: Bool) {
        super.init(frame: CGRect.zero)
        
        setUpView(isChecked: isChecked)
    }
    
    private func setUpView(isChecked: Bool) {
        self.isChecked = isChecked
    }
    
    func tap() {
        isChecked = !isChecked
    }

}
