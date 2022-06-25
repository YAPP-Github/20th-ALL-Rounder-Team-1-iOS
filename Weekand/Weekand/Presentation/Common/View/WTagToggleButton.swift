//
//  WToggleButton.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit

protocol WToggleButtonType {
    associatedtype Status
    
    var cornerRadius: CGFloat { get }
    var edgeInset: UIEdgeInsets { get }
    var contentInsets: NSDirectionalEdgeInsets { get }
}

class WTagToggleButton: UIButton, WToggleButtonType {
    
    enum Status {
        case checked, unchecked
        
        var backGroundColor: UIColor {
            switch self {
            case .checked: return .subColor!
            case .unchecked: return .gray100!
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .checked: return .mainColor
            case .unchecked: return .gray400
            }
        }
    }
    
    let cornerRadius: CGFloat = 108
    let edgeInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
    let contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setupView(style: .checked)
            } else {
                self.setupView(style: .unchecked)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    private func setupView(style: Status) {

        self.titleLabel?.adjustsFontSizeToFitWidth = false
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = style.backGroundColor
            configuration.baseForegroundColor = style.titleColor
            configuration.background.cornerRadius = cornerRadius
            configuration.contentInsets = contentInsets
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = cornerRadius
            self.backgroundColor = style.backGroundColor
            self.setTitleColor(style.titleColor, for: .normal)
            self.contentEdgeInsets = edgeInset
        }
        
    }
    
    init(title: String, style: Status, font: UIFont) {
        super.init(frame: CGRect.zero)
        
        setTitle(title, for: .normal, font: font)
        setupView(style: style)
    }
    
    convenience init(title: String, font: UIFont) {
        self.init(title: title, style: .unchecked, font: font)
    }

}

// MARK: Button Customization Methods
extension WTagToggleButton {
    
    func setTitle(_ title: String?, for state: UIControl.State, font: UIFont) {
        self.setTitle(title, for: state)
        
        guard let text = title else { return }
        let attribute = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute as [NSAttributedString.Key: Any])
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
}
