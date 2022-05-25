//
//  WTextButton.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit

class WTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray!, NSAttributedString.Key.font: UIFont(name: "PretendardVariable-Bold", size: defaultFontSize)!])
        self.setAttributedTitle(titleString, for: .normal)
    }
    

}
