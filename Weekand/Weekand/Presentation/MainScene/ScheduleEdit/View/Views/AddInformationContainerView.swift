//
//  AddInformationStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import UIKit

class AddInformationContainerView: UIView {

    lazy var addCategoryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "plus.circle.fill")?.withTintColor(.mainColor)
        $0.setImage(buttonImage, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var repeatButton = WDefaultButton(title: "반복", style: .tint, font: WFont.body2())
    lazy var memoButton = WDefaultButton(title: "메모", style: .tint, font: WFont.body2())
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        [addCategoryButton, repeatButton, memoButton].forEach { self.addSubview($0) }
        
        addCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(repeatButton.snp.top).inset(10)
            make.leading.equalToSuperview()
        }
        
        repeatButton.snp.makeConstraints { make in
            make.leading.equalTo(addCategoryButton.snp.trailing).offset(12)
            make.width.equalTo(57)
            make.height.equalTo(42)
        }
        
        memoButton.snp.makeConstraints { make in
            make.leading.equalTo(repeatButton.snp.trailing).offset(12)
            make.width.equalTo(57)
            make.height.equalTo(42)
        }
        
    }

}
