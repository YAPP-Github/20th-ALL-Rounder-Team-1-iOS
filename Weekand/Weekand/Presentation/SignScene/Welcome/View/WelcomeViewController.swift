//
//  WelcomeViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit
import SnapKit
import Then

class WelcomeViewController: UIViewController {
    
    
    lazy var logoView = UIImageView().then {
        $0.backgroundColor = .mainColor     // TODO: Add real Weekand logo image
    }
    
    lazy var introLabel = UILabel().then {
        $0.text = "야! 너두 할수있어!"
        $0.font = UIFont(name: "PretendardVariable-Bold", size: defaultFontSize*1.5)
    }
    
    lazy var titleStack = UIStackView().then {
        $0.addArrangedSubview(logoView)
        $0.addArrangedSubview(introLabel)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    lazy var signInButton = WDefaultButton(title: "로그인", style: .filled)
    lazy var signUpButton = WDefaultButton(title: "회원가입", style: .tint)
    
    lazy var buttonStack = UIStackView().then {
        $0.addArrangedSubview(signInButton)
        $0.addArrangedSubview(signUpButton)
        
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview().dividedBy(2)
        }
        
        self.view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview().dividedBy(0.75)
        }
    }

}

import SwiftUI

#if canImport(SwiftUI) && DEBUG

struct WelcomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeViewController().showPreview(.iPhone8)
            WelcomeViewController().showPreview(.iPhone12Mini)
        }
    }
}
#endif
