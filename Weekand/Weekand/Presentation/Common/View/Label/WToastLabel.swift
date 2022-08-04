//
//  WToastMessage.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/08.
//

import UIKit

class WToastLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textColor = UIColor.white
        textAlignment = .center
        alpha = 1.0
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    func setMessage(text: String, font: UIFont, frame: CGRect) {
        self.font = font
        self.text = text
        self.frame = frame
    }
}
