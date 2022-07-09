//
//  UIButton+setImageInset.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/14.
//

import UIKit

extension UIButton {
    
    func setImageInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        
        
        if #available(iOS 15.0, *) {
            if self.configuration != nil {
                self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
            } else {
                var configuration = UIButton.Configuration.filled()
                configuration.contentInsets = NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
                self.configuration = configuration
            }
            
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
        
    }
}
