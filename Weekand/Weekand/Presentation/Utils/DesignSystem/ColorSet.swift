//
//  Color.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/20.
//

import UIKit

extension UIColor {
    // MARK: Custom System Colors
    static let mainColor = UIColor(hex: "#5086FF") ?? .systemBlue
    static let subColor = UIColor(hex: "#EAF0FF")
    static let backgroundColor = UIColor.white
    
    static let accentColor = UIColor(hex: "#17191C")
    static let lightGray = UIColor(hex: "#ECEFF2")
    static let darkGray = UIColor(hex: "#AAAEB6")
    
    static let gray900 = UIColor(hex: "#17191C") ?? .black
    static let gray800 = UIColor(hex: "#32353A") ?? .black
    static let gray700 = UIColor(hex: "#515459") ?? .black
    static let gray600 = UIColor(hex: "#747880") ?? .systemGray6
    static let gray500 = UIColor(hex: "#8B929C") ?? .systemGray6
    static let gray400 = UIColor(hex: "#AAAEB6") ?? .systemGray

    static let gray300 = UIColor(hex: "#C9CED5") ?? .systemGray
    static let gray200 = UIColor(hex: "#ECEFF2") ?? .systemGray
    static let gray100 = UIColor(hex: "#F5F7F8") ?? .systemGray
    static let wred = UIColor(hex: "#FF7562") ?? .systemRed
    static let wblue = UIColor(hex: "#5086FF") ?? .systemBlue

}
