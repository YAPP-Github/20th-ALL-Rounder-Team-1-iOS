//
//  WelcomeViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: WelcomeViewModel?
    
    lazy var logoView = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }
    
    lazy var introLabel = UILabel().then {
        $0.text = "We can do, Week and!"
        $0.font = WFont.head1()
    }
    
    lazy var titleStack = UIStackView().then {
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .leading
    }
    
    lazy var signInButton = WDefaultButton(title: "로그인", style: .filled, font: WFont.subHead1())
    lazy var signUpButton = WDefaultButton(title: "회원가입", style: .tint, font: WFont.subHead1())
    
    lazy var buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        [ logoView, introLabel ].forEach { titleStack.addArrangedSubview($0) }
        logoView.snp.makeConstraints { make in
            make.width.equalTo(148)
            make.height.equalTo(40)
        }
        
        [ signInButton, signUpButton ].forEach { buttonStack.addArrangedSubview($0) }
        
        [ titleStack, buttonStack ].forEach { self.view.addSubview($0)}
        titleStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview().dividedBy(2)
        }
                
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(defaultWidthDivider)
            make.centerY.equalToSuperview().dividedBy(0.75)
        }
    }
    
    private func bindViewModel() {
        let input = WelcomeViewModel.Input(
            didTapSignInButton: self.signInButton.rx.tap.asObservable(),
            didTapSignUpButton: self.signUpButton.rx.tap.asObservable()
        )
        
        self.viewModel?.transform(input: input)
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
