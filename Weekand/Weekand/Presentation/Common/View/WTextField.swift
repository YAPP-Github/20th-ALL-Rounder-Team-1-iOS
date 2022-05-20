//
//  WTextField.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/19.
//

import UIKit

class WTextField: UITextField {
    
    let inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

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
        self.layer.cornerRadius = 13
        self.backgroundColor = UIColor.lightGray
        
        // Main Text
        self.font = UIFont(name: "PretendardVariable", size: UIFont.labelFontSize)
        
        // Placeholder Text
        self.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!])
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
