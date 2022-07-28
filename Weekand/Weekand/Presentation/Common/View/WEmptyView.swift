//
//  WEmptyView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/25.
//

import UIKit

class WEmptyView: UIView {
    
    let logoView = UIImageView()
    
    lazy var namelabel = WMultiLineTextLabel().then {
        $0.textColor = UIColor.gray400
        $0.font = WFont.body1()
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpView() {
        self.addSubview(logoView)
        self.addSubview(namelabel)
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(screenHeight/2 - 150)
            make.leading.equalTo(screenWidth/2 - 35)
        }
        
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(20)
            make.centerX.equalTo(logoView.snp.centerX)
        }
    }
    
    init(type: EmptySceneType) {
        super.init(frame: CGRect.zero)
        
        self.logoView.image = UIImage(named: type.imageName) ?? UIImage()
        self.namelabel.text = type.informText
        
        setUpView()
    }
}
