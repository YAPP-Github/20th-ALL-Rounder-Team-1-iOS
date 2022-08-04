//
//  WEmptyView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/25.
//

import UIKit

class WEmptyView: UIView {
    
    let logoView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var namelabel = WMultiLineTextLabel().then {
        $0.textColor = UIColor.gray400
        $0.font = WFont.body1()
        $0.textAlignment = .center
    }
    
    lazy var stack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpView() {
        [logoView, namelabel].forEach { stack.addArrangedSubview($0) }
        
        logoView.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
            
        self.addSubview(stack)
        stack.setContentHuggingPriority(.required, for: .vertical)
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
    }
    
    init(type: EmptySceneType) {
        super.init(frame: CGRect.zero)
        
        self.logoView.image = UIImage(named: type.imageName) ?? UIImage()
        self.namelabel.text = type.informText
        
        setUpView()
    }
}
