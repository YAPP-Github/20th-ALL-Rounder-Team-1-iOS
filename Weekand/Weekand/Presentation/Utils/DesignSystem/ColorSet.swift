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
    static let gray800 = UIColor(hex: "#32353A")
    static let gray700 = UIColor(hex: "#515459")
    static let gray600 = UIColor(hex: "#747880")
    static let gray500 = UIColor(hex: "#8B929C") 
    static let gray400 = UIColor(hex: "#AAAEB6") ?? .systemGray

    static let gray300 = UIColor(hex: "#C9CED5") ?? .systemGray
    static let gray200 = UIColor(hex: "#ECEFF2")
    static let gray100 = UIColor(hex: "#F5F7F8")
    static let wred = UIColor(hex: "#FF7562") ?? .red
    static let wblue = UIColor(hex: "#5086FF")

}

extension UIColor {
    static let categoryColors =
    [[UIColor(hex: "#FF9292"), UIColor(hex: "#FFB27A"), UIColor(hex: "#FFE600"), UIColor(hex: "#94EB9C"), UIColor(hex: "#67DBFF"), UIColor(hex: "#83A5FF"), UIColor(hex: "#C081FF")],
     [UIColor(hex: "#FFA6A6"), UIColor(hex: "#FFC59B"), UIColor(hex: "#FFF278"), UIColor(hex: "#B6EEBC"), UIColor(hex: "#A6EAFF"), UIColor(hex: "#B1C7FF"), UIColor(hex: "#D4AAFF")],
     [UIColor(hex: "#FFC8C8"), UIColor(hex: "#FFDEC7"), UIColor(hex: "#FFF7AC"), UIColor(hex: "#D8F5DB"), UIColor(hex: "#CFF3FF"), UIColor(hex: "#D8E3FF"), UIColor(hex: "#E9D3FF")]]
}
