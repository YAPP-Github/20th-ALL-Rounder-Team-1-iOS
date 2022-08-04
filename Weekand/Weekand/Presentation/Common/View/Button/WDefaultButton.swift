//
//  WDefaultButton.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit

enum WButtonStyle {
    case filled, tint, type, typePressed, tag, tagPressed
    
    var backGroundColor: UIColor {
        switch self {
        case .filled: return .mainColor
        case .tint: return .subColor!
        case .type: return .gray100
        case .typePressed: return .subColor!
        case .tag: return .gray100
        case .tagPressed: return .subColor!
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .filled: return .white
        case .tint: return .mainColor
        case .type: return .gray400
        case .typePressed: return .mainColor
        case .tag: return .gray400
        case .tagPressed: return .mainColor
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .filled: return 12
        case .tint: return 12
        case .type: return 10
        case .typePressed: return 10
        case .tag: return 108
        case .tagPressed: return 108
        }
    }
}

class WDefaultButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    private func setupView(style: WButtonStyle) {

        self.titleLabel?.adjustsFontSizeToFitWidth = false
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = style.backGroundColor
            configuration.baseForegroundColor = style.titleColor
            configuration.background.cornerRadius = style.cornerRadius
            configuration.contentInsets = NSDirectionalEdgeInsets.defaultEdgeInset
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = style.cornerRadius
            self.backgroundColor = style.backGroundColor
            self.setTitleColor(style.titleColor, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets.defaultEdgeInset
        }
        
    }
    
    init(title: String, style: WButtonStyle, font: UIFont) {
        super.init(frame: CGRect.zero)
        
        setTitle(title, for: .normal, font: font)
        setupView(style: style)
    }
    
    convenience init(title: String, font: UIFont) {
        self.init(title: title, style: .filled, font: font)
    }

}

// MARK: Button Customization Methods
extension WDefaultButton {
    
    func setTitle(_ title: String?, for state: UIControl.State, font: UIFont) {
        self.setTitle(title, for: state)
        
        guard let text = title else { return }
        let attribute = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute as [NSAttributedString.Key: Any])
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setButtonColor(_ title: String, foregroundColor: UIColor, backgroundColor: UIColor) {
        
        if #available(iOS 15.0, *) {
            self.configuration?.background.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = backgroundColor
        }
        let attribute = [NSAttributedString.Key.foregroundColor: foregroundColor,
                         NSAttributedString.Key.font: WFont.body2()]
        let attributedTitle = NSAttributedString(string: title, attributes: attribute as [NSAttributedString.Key: Any])
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setUpStyle(_ title: String?, font: UIFont, style: WButtonStyle) {
        self.setTitle(title, for: .normal, font: font)
        
        self.titleLabel?.adjustsFontSizeToFitWidth = false
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = style.backGroundColor
            configuration.baseForegroundColor = style.titleColor
            configuration.background.cornerRadius = style.cornerRadius
            configuration.contentInsets = NSDirectionalEdgeInsets.defaultEdgeInset
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = style.cornerRadius
            self.backgroundColor = style.backGroundColor
            self.setTitleColor(style.titleColor, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets.defaultEdgeInset
        }

    }
    
}
