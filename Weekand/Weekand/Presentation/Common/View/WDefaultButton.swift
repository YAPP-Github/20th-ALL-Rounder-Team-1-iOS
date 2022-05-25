//
//  WDefaultButton.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit

enum WButtonStyle {
    case filled, tint
    
    var backGroundColor: UIColor {
        switch self {
        case .filled: return .mainColor!
        case .tint: return .subColor!
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .filled: return .white
        case .tint: return .mainColor!
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
        
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.font = UIFont(name: "PretendardVariable", size: defaultFontSize)
        self.setTitleColor(style.titleColor, for: .normal)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = style.backGroundColor
            configuration.background.cornerRadius = defaultCornerRadius
            configuration.contentInsets = NSDirectionalEdgeInsets.defaultEdgeInset
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = defaultCornerRadius
            self.backgroundColor = style.backGroundColor
            self.titleEdgeInsets = UIEdgeInsets.defaultEdgeInset
        }
    }
    
    init(title: String, style: WButtonStyle) {
        super.init(frame: CGRect.zero)
        
        setupView(style: style)
        self.setTitle(title, for: .normal)
    }
    
    convenience init(title: String) {
        self.init(title: title, style: .filled)
    }

}
