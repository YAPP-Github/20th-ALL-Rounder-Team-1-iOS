//
//  WTitleLabel.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/24.
//

import UIKit

class WTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        font = WFont.title()
        numberOfLines = 0
    }
    
    func setText(string: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        let attrString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        attributedText = attrString
    }

}
