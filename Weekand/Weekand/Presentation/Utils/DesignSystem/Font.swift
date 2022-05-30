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
    
    func head1() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 15)!
    }
    
    func head2() -> UIFont {
        return UIFont(name: WFont.bold.rawValue, size: 13.5)!
    }
    
    func subHead1() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 13.5)!
    }
    
    func subHead2() -> UIFont {
        return UIFont(name: WFont.semiBold.rawValue, size: 12)!
    }
    
    func body1() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 12)!
    }
    
    func body2() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 10.5)!
    }
    
    func body3() -> UIFont {
        return UIFont(name: WFont.medium.rawValue, size: 9)!
    }
    
}
