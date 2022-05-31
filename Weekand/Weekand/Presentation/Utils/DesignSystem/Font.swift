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
        return UIFont(name: self.rawValue, size: size)!
    }
    
    static func head1() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 20)!
    }
    
    static func head2() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 18)!
    }
    
    static func subHead1() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 18)!
    }
    
    static func subHead2() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 16)!
    }
    
    static func body1() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 16)!
    }
    
    static func body2() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 14)!
    }
    
    static func body3() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 12)!

    }
    
}
