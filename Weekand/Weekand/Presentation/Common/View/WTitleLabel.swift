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
        font = UIFont(name: "PretendardVariable-Bold", size: 22)
        numberOfLines = 0
    }
    
    func setText(string: String) {
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        // legacy code
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        attributedText = attrString
    }

}
