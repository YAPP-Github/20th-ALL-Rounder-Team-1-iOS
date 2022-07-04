//
//  SignUpTermsViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class SignUpTermsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: SignUpTermsViewModel?
    
    lazy var wholeAgreeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    lazy var checkBoxButton = WCheckBox()
    
    lazy var wholeAgreeLabel = WTitleLabel().then {
        $0.setText(string: "전체 동의")
        $0.font = WFont.head2()
    }
    
    lazy var wholeAgreeInformLabel = WTextLabel().then {
        $0.textColor = .gray500
        $0.text = "약관 비동의 시 서비스 이용이 불가합니다."
    }
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    let termsAgreeCheckBoxButton = WCheckBox()
    
    lazy var termsAgreeLabel = WTextLabel().then {
        $0.attributedText = NSMutableAttributedString()
            .semiBold("이용약관", fontSize: defaultFontSize, fontColor: .wblue)
            .semiBold("에 동의합니다.", fontSize: defaultFontSize, fontColor: .gray700)
    }
    
    lazy var privacyAgreeCheckBoxButton = WCheckBox()
    
    lazy var privacyAgreeLabel = WTextLabel().then {
        $0.attributedText = NSMutableAttributedString()
            .semiBold("개인정보 취급방식", fontSize: defaultFontSize, fontColor: .wblue)
            .semiBold("에 동의합니다.", fontSize: defaultFontSize, fontColor: .gray700)
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("로그인 하러가기", for: .normal)
        $0.enable(string: "로그인 하러가기")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "약관 동의"
    }
    
    private func configureUI() {
        view.addSubview(wholeAgreeStackView)
        wholeAgreeStackView.addArrangedSubview(checkBoxButton)
        wholeAgreeStackView.addArrangedSubview(wholeAgreeLabel)
        wholeAgreeStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        view.addSubview(wholeAgreeInformLabel)
        wholeAgreeInformLabel.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeStackView.snp.bottom).offset(10)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(dividerLine)
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeInformLabel.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        view.addSubview(termsAgreeCheckBoxButton)
        termsAgreeCheckBoxButton.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(30)
            make.leading.equalTo(checkBoxButton.snp.leading)
        }
        
        view.addSubview(termsAgreeLabel)
        termsAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(termsAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(privacyAgreeCheckBoxButton)
        privacyAgreeCheckBoxButton.snp.makeConstraints { make in
            make.top.equalTo(termsAgreeLabel.snp.bottom).offset(30)
            make.leading.equalTo(checkBoxButton.snp.leading)
        }
        
        view.addSubview(privacyAgreeLabel)
        privacyAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    private func bindViewModel() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let input = SignUpTermsViewModel.Input(
            nextButtonDidTapEvent: confirmButton.rx.tap.asObservable()
        )
        
        let _ = viewModel.transform(input: input)
    }
}

#if canImport(SwiftUI) && DEBUG

struct SignUpTermsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpTermsViewController().showPreview(.iPhone8)
        }
    }
}
#endif
