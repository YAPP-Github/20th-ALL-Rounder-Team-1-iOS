//
//  WCheckBox.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit

class WCheckBox: UIButton {
    
    let checkedImage = UIImage(named: "checkmark.fill")!.withTintColor(.gray300)
    let uncheckedImage = UIImage(named: "checkmark.fill")!.withTintColor(.mainColor)

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
    
    convenience init() {
        self.init(isChecked: false)
    }
    
    private func setUpView(isChecked: Bool) {
        self.isChecked = isChecked
    }
    
    func tap() {
        isChecked = !isChecked
    }

}
