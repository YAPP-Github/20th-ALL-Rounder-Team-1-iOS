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
import WebKit

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
    
    lazy var termsAgreeButton = UIButton().then {
        let attributedString = NSMutableAttributedString(
                                string: "이용약관",
                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                             NSAttributedString.Key.font: WFont.subHead2(),
                                             NSAttributedString.Key.foregroundColor: UIColor.mainColor]
                            )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .clear
    }
    
    lazy var termsAgreeLabel = WTextLabel().then {
        $0.text = "에 동의합니다."
        $0.font = WFont.subHead2()
        $0.textColor = .gray600
    }
    
    lazy var privacyAgreeCheckBoxButton = WCheckBox()
    
    lazy var privacyAgreeButton = UIButton().then {
        let attributedString = NSMutableAttributedString(
                                string: "개인정보 취급방식",
                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                             NSAttributedString.Key.font: WFont.subHead2(),
                                             NSAttributedString.Key.foregroundColor: UIColor.mainColor]
                            )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .clear
    }
    
    lazy var privacyAgreeLabel = WTextLabel().then {
        $0.text = "에 동의합니다."
        $0.font = WFont.subHead2()
        $0.textColor = .gray600
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
        
        view.addSubview(termsAgreeButton)
        termsAgreeButton.snp.makeConstraints { make in
            make.centerY.equalTo(termsAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(termsAgreeLabel)
        termsAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(termsAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(termsAgreeButton.snp.trailing)
        }
        
        view.addSubview(privacyAgreeCheckBoxButton)
        privacyAgreeCheckBoxButton.snp.makeConstraints { make in
            make.top.equalTo(termsAgreeLabel.snp.bottom).offset(30)
            make.leading.equalTo(checkBoxButton.snp.leading)
        }
        
        view.addSubview(privacyAgreeButton)
        privacyAgreeButton.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(privacyAgreeLabel)
        privacyAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeCheckBoxButton.snp.centerY)
            make.leading.equalTo(privacyAgreeButton.snp.trailing)
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
            termsAgreeButtonDidTapEvent: termsAgreeButton.rx.tap.asObservable(),
            privacyAgreeButtonDidTapEvent: privacyAgreeButton.rx.tap.asObservable(),
            nextButtonDidTapEvent: confirmButton.rx.tap.asObservable()
        )
        
        termsAgreeButton.rx.tap.subscribe(onNext: {
            let url = URL(string: "https://typhoon-river-8ba.notion.site/a20528198b2f491fa3b6997c71156c42")!
            let request = URLRequest(url: url)

            self.termsAgreeWebView.load(request)
        }).disposed(by: disposeBag)
        
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
