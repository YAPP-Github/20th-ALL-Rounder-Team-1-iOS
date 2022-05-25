//
//  WTextField.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/19.
//

import UIKit

class WTextField: UITextField {
    
    let inset = UIEdgeInsets.defaultEdgeInset

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        
        // Shape
        self.layer.cornerRadius = defaultCornerRadius
        self.backgroundColor = UIColor.lightGray
        
        // Main Text
        self.font = UIFont(name: "PretendardVariable", size: defaultFontSize)
        
        
        // Placeholder Text
        self.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!])
    }
    
    init(placeHolder: String) {
        super.init(frame: CGRect.zero)
        
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!])
    }

}


// MARK: Text Padding
extension WTextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
}
