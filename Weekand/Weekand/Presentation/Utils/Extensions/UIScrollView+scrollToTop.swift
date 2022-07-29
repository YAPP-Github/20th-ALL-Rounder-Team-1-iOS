//
//  UIScrollView+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/15.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: false)
    }
}
