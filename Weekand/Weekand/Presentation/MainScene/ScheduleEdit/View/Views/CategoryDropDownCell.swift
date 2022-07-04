//
//  CategoryDropDownCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import DropDown

class CategoryDropDownCell: DropDownCell {

    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 3
        optionLabel.textColor = .gray900
        optionLabel.font = WFont.body1()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
