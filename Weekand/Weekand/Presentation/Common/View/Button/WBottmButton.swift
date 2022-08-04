//
//  WBottmButton.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/23.
//

import UIKit

class WBottmButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.font = WFont.subHead1()
        
        self.contentVerticalAlignment = .top
    }
    
    private func setupDisableState() {
        isEnabled = false
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = UIColor.gray300
            configuration.background.cornerRadius = 0
            configuration.contentInsets.top = NSDirectionalEdgeInsets.defaultInsetAmount
            self.configuration = configuration
        } else {
            self.layer.cornerRadius = 0
            self.backgroundColor = UIColor.gray300
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets.top = UIEdgeInsets.defaultInsetAmount
        }
    }
    
    func enable(string: String) {
        isEnabled = true
        setTitle(string, for: .normal)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = UIColor.mainColor
            configuration.background.cornerRadius = 0
            configuration.contentInsets.top = NSDirectionalEdgeInsets.defaultInsetAmount
            self.configuration = configuration
        } else {
            self.layer.cornerRadius = 0
            self.backgroundColor = UIColor.mainColor
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets.top = UIEdgeInsets.defaultInsetAmount
        }
    }
    
    func disable(string: String) {
        setTitle(string, for: .normal)
        setupDisableState()
    }
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        self.setTitle(title, for: .normal)
    }
}

extension WBottmButton {
    static let buttonOffset = 50
}
