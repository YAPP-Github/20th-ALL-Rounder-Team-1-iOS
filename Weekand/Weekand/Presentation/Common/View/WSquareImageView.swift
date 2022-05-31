//
//  WSquareImageView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/31.
//

import UIKit
import SnapKit

class WSquareImageView: UIImageView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    
    private func setupView() {
        
        self.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
        }
    }
    
}
