//
//  WArrowButton.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit

class WArrowButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView() {
        backgroundColor?.withAlphaComponent(0)
        let buttonImage = UIImage(named: "arrow.down")?.withTintColor(.gray700)
        setImage(buttonImage, for: .normal)
    }

}
