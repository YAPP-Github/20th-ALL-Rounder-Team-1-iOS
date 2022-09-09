//
//  SortDropDownCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/07.
//

import UIKit
import DropDown

class SortDropDownCell: DropDownCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionLabel.textColor = .gray700
        optionLabel.font = WFont.body1()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
