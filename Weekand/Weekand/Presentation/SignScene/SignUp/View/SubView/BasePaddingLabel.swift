//
//  BasePaddingLabel.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/10.
//

import UIKit


class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
