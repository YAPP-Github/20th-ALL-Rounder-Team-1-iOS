//
//  Font.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import Foundation
import UIKit

enum WFont: String {
    
    case regular = "PretendardVariable-Regular"
    case thin = "PretendardVariable-Thin"
    case extraLight = "PretendardVariable-ExtraLight"
    case light = "PretendardVariable-Light"
    case medium = "PretendardVariable-Medium"
    case semiBold = "PretendardVariable-SemiBold"
    case bold = "PretendardVariable-Bold"
    case extraBold = "PretendardVariable-extraBold"
    case black = "PretendardVariable-black"


    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func title() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 22) ?? UIFont.systemFont(ofSize: 22)
    }
    
    static func head1() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20)
    }
    
    static func head2() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
    }
    
    static func subHead1() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
    }
    
    static func subHead2() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static func subHead3() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static func body1() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static func body2() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static func body3() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static func body4() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10)
    }
    
}
