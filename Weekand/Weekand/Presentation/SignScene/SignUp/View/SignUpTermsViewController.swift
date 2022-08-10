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
    
    lazy var wholeAgreecheckBoxButton = WCheckBox(isChecked: false)
    
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
    
    let termsAgreeCheckBoxButton = WCheckBox(isChecked: false)
    
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
    
    lazy var privacyAgreeCheckBoxButton = WCheckBox(isChecked: false)
    
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
        $0.disable(string: "로그인 하러가기")
    }
    
    let termsAgree = PublishRelay<Bool>()
    let privacyAgree = PublishRelay<Bool>()
    let wholeAgree = PublishRelay<Bool>()
    
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
        view.addSubview(wholeAgreecheckBoxButton)
        
        wholeAgreecheckBoxButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        view.addSubview(wholeAgreeLabel)
        wholeAgreeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(wholeAgreecheckBoxButton.snp.trailing).offset(10)
        }
        
        view.addSubview(wholeAgreeInformLabel)
        wholeAgreeInformLabel.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeLabel.snp.bottom).offset(10)
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
            make.leading.equalTo(wholeAgreecheckBoxButton.snp.leading)
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
            make.leading.equalTo(wholeAgreecheckBoxButton.snp.leading)
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
        
        self.termsAgreeCheckBoxButton.rx.tap.subscribe(onNext: {
            self.termsAgreeCheckBoxButton.isChecked = !self.termsAgreeCheckBoxButton.isChecked
            self.termsAgree.accept(self.termsAgreeCheckBoxButton.isChecked)
        }).disposed(by: disposeBag)
        
        self.privacyAgreeCheckBoxButton.rx.tap.subscribe(onNext: {
            self.privacyAgreeCheckBoxButton.isChecked = !self.privacyAgreeCheckBoxButton.isChecked
            self.privacyAgree.accept(self.privacyAgreeCheckBoxButton.isChecked)
        }).disposed(by: disposeBag)
        
        self.wholeAgreecheckBoxButton.rx.tap.subscribe(onNext: {
            self.wholeAgreecheckBoxButton.isChecked = !self.wholeAgreecheckBoxButton.isChecked
            self.termsAgreeCheckBoxButton.isChecked = self.wholeAgreecheckBoxButton.isChecked
            self.privacyAgreeCheckBoxButton.isChecked = self.wholeAgreecheckBoxButton.isChecked
            self.wholeAgree.accept(self.wholeAgreecheckBoxButton.isChecked)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(termsAgree, privacyAgree).subscribe(onNext: { terms, privacy in
            if terms == false {
                self.wholeAgreecheckBoxButton.isChecked = false
                self.wholeAgree.accept(false)
            }
            
            if privacy == false {
                self.wholeAgreecheckBoxButton.isChecked = false
                self.wholeAgree.accept(false)
            }
            
            if terms && privacy {
                self.wholeAgreecheckBoxButton.isChecked = true
                self.wholeAgree.accept(true)
            }
        })
        .disposed(by: disposeBag)
        
        termsAgreeButton.rx.tap.subscribe(onNext: {
            if let url = URL(string: "https://wirehaired-dryosaurus-4eb.notion.site/2e0a116f69cb4bb0bc08ffac531c01e7") {
                UIApplication.shared.open(url)
            }
        }).disposed(by: disposeBag)
        
        privacyAgreeButton.rx.tap.subscribe(onNext: {
            if let url = URL(string: "https://wirehaired-dryosaurus-4eb.notion.site/60bfebd307f547f3800b02d2f0384021") {
                UIApplication.shared.open(url)
            }
        }).disposed(by: disposeBag)
        
        wholeAgree.subscribe(onNext: { isChecked in
            if isChecked {
                self.confirmButton.enable(string: "로그인 하러가기")
            } else {
                self.confirmButton.disable(string: "로그인 하러가기")
            }
        })
        .disposed(by: disposeBag)
        
        let input = SignUpTermsViewModel.Input(
            nextButtonDidTapEvent: confirmButton.rx.tap.asObservable()
        )

        viewModel.transform(input: input)
    }
}
