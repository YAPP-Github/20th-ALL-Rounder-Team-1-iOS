//
//  WTitleLabel.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/24.
//

import UIKit

class WTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        font = UIFont(name: "PretendardVariable", size: 22)
        numberOfLines = 0
    }

}
