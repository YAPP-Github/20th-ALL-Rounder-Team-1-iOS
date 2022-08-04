//
//  WTagToggleButton.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit

class WTypeToggleButton: UIButton, WToggleButtonType {
    
    enum Status {
        case checked, unchecked
        
        var titleColor: UIColor {
            switch self {
            case .checked: return .mainColor
            case .unchecked: return .gray400
            }
        }
        
        var backGroundColor: UIColor {
            switch self {
            case .checked: return .subColor!
            case .unchecked: return .gray100
            }
        }
    }
    
    let cornerRadius: CGFloat = 10
    let edgeInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    let contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
    
    var title: String = ""
    var font: UIFont = WFont.body1()
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setupView(style: .checked)
                self.setTitle(title, for: .normal, font: font)
            } else {
                self.setupView(style: .unchecked)
                self.setTitle(title, for: .normal, font: font)
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
        
        self.title = title
        self.font = font
        setTitle(title, for: .normal, font: font)
        setupView(style: style)
    }
}

// MARK: Button Customization Methods
extension WTypeToggleButton {
    
    func setTitle(_ title: String?, for state: UIControl.State, font: UIFont) {
        self.setTitle(title, for: state)
        
        guard let text = title else { return }
        let attribute = [NSAttributedString.Key.font: font]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute as [NSAttributedString.Key: Any])
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
}
