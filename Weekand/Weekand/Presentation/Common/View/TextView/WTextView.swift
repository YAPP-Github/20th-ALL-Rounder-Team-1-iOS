//
//  WTextView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import UIKit

class WTextView: UITextView {
    
    var placeHolder = ""

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        // Scroll
        self.isScrollEnabled = false
        
        // Shape
        self.layer.cornerRadius = defaultCornerRadius
        self.backgroundColor = .gray200
        
        // Main Text
        self.font = WFont.body1()
        self.textColor = .gray900
        self.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }
    
    func setPlaceHolder(_ text: String) {
        placeHolder = text
        self.text = text
    }

}
