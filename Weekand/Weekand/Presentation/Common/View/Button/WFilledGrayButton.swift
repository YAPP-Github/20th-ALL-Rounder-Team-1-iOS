//
//  WFilledGrayButton.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit

class WFilledGrayButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {

        self.titleLabel?.adjustsFontSizeToFitWidth = false
        self.contentHorizontalAlignment = .left
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = .gray200
            configuration.baseForegroundColor = .gray900
            configuration.background.cornerRadius = 12
            configuration.contentInsets = NSDirectionalEdgeInsets.defaultEdgeInset
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = 12
            self.backgroundColor = .gray200
            self.setTitleColor(.gray900, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets.defaultEdgeInset
        }
        
    }
    
    init(title: String, font: UIFont) {
        super.init(frame: CGRect.zero)
        
        setTitle(title, for: .normal, font: font)
        setupView()
    }

}

// MARK: Button Customization Methods
extension WFilledGrayButton {
    
    func setTitle(_ title: String?, for state: UIControl.State, font: UIFont) {
        self.setTitle(title, for: state)
        
        guard let text = title else { return }
        let attribute = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute as [NSAttributedString.Key: Any])
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
}
