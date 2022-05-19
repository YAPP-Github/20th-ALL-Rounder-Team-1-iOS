//
//  Colors.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/19.
//

import UIKit

extension UIColor {

    // MARK: UIColor with Hex
    public convenience init?(hex: String) {
        
        var safeHex = hex
        if hex.count == 7 {
            safeHex += "FF"
        }
        
        let r, g, b, a: CGFloat

        if safeHex.hasPrefix("#") {
            let start = safeHex.index(safeHex.startIndex, offsetBy: 1)
            let hexColor = String(safeHex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
