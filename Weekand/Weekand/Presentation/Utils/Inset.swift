//
//  UIEdgeInset+defaultInset.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    static let defaultInsetAmount: CGFloat = 15.0
    static var defaultEdgeInset = UIEdgeInsets(top: defaultInsetAmount, left: defaultInsetAmount, bottom: defaultInsetAmount, right: defaultInsetAmount)
    
    static var internalEdgeInset = UIEdgeInsets(top: defaultInsetAmount/2, left: defaultInsetAmount, bottom: defaultInsetAmount/2, right: defaultInsetAmount)

    
    static public func / (left: UIEdgeInsets, right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: left.top/right, left: left.left/right, bottom: left.bottom/right, right: left.right/right)
    }
}

extension NSDirectionalEdgeInsets {
    
    static let defaultInsetAmount: CGFloat = 15.0
    static var defaultEdgeInset = NSDirectionalEdgeInsets(top: defaultInsetAmount, leading: defaultInsetAmount, bottom: defaultInsetAmount, trailing: defaultInsetAmount)
    
    static var internalEdgeInset = NSDirectionalEdgeInsets(top: defaultInsetAmount/2, leading: defaultInsetAmount, bottom: defaultInsetAmount/2, trailing: defaultInsetAmount)
    
    static public func / (left: NSDirectionalEdgeInsets, right: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: left.top/right, leading: left.leading/right, bottom: left.bottom/right, trailing: left.trailing/right)
    }

}
