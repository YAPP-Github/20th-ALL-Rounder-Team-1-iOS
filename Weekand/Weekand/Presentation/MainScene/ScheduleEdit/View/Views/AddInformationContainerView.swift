//
//  AddInformationStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/05.
//

import UIKit

class AddInformationContainerView: UIStackView {

    lazy var addCategoryButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        let buttonImage = UIImage(named: "plus.circle.fill")?.withTintColor(.mainColor)
        $0.setImage(buttonImage, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var repeatButton = WDefaultButton(title: "반복", style: .tint, font: WFont.body2())
    lazy var memoButton = WDefaultButton(title: "메모", style: .tint, font: WFont.body2())
    
    let spacerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .horizontal
        distribution = .fill
        spacing = 10
        
        [addCategoryButton, repeatButton, memoButton, spacerView].forEach { self.addArrangedSubview($0) }
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        repeatButton.snp.makeConstraints { make in
            make.width.equalTo(57)
            make.height.equalTo(42)
        }

        memoButton.snp.makeConstraints { make in
            make.width.equalTo(57)
            make.height.equalTo(42)
        }
        
    }

}
