//
//  NSMutableAttributedString+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit

extension NSMutableAttributedString {

    func semiBold(_ value: String, font: UIFont, fontColor: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func bold(_ value: String, font: UIFont, fontColor: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    @discardableResult
    func normal(_ value: String, font: UIFont, fontColor: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
