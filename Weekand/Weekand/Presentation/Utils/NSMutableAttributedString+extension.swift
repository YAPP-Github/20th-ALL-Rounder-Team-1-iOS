//
//  NSMutableAttributedString+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit

extension NSMutableAttributedString {

    func semiBold(_ value: String, fontSize: CGFloat, fontColor: UIColor) -> NSMutableAttributedString {
        let font = UIFont(name: "PretendardVariable-SemiBold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func bold(_ value: String, fontSize: CGFloat, fontColor: UIColor) -> NSMutableAttributedString {
        let font = UIFont(name: "PretendardVariable-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func normal(_ value: String, fontSize: CGFloat, fontColor: UIColor) -> NSMutableAttributedString {
        let font = UIFont(name: "PretendardVariable-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fontColor
        ]

        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
