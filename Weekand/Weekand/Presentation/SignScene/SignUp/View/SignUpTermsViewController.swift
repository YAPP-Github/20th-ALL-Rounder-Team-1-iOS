//
//  SignUpTermsViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit
import SwiftUI

class SignUpTermsViewController: UIViewController {

    lazy var wholeAgreeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    lazy var checkBoxButton = UIButton().then {
        $0.backgroundColor = .gray300
    }
    
    lazy var wholeAgreeLabel = WTitleLabel().then {
        $0.setText(string: "전체 동의")
    }
    
    lazy var wholeAgreeInformLabel = WTextLabel().then {
        $0.textColor = .gray500
        $0.text = "약관 비동의 시 서비스 이용이 불가합니다."
    }
    
    lazy var dividingLineView = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    lazy var termsAgreeCheckBoxButton = UIButton().then {
        $0.backgroundColor = .gray300
    }
    
    lazy var termsAgreeLabel = WTextLabel().then {
        $0.attributedText = NSMutableAttributedString()
            .semiBold("이용약관", fontSize: defaultFontSize, fontColor: .wblue ?? .black)
            .semiBold("에 동의합니다.", fontSize: defaultFontSize, fontColor: .gray700 ?? .black)
    }
    
    lazy var privacyAgreeCheckBoxButton = UIButton().then {
        $0.backgroundColor = .gray300
    }
    
    lazy var privacyAgreeLabel = WTextLabel().then {
        $0.attributedText = NSMutableAttributedString()
            .semiBold("개인정보 취급방식", fontSize: defaultFontSize, fontColor: .wblue ?? .black)
            .semiBold("에 동의합니다.", fontSize: defaultFontSize, fontColor: .gray700 ?? .black)
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("완료", for: .normal)
        $0.enable(string: "완료")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(wholeAgreeStackView)
        wholeAgreeStackView.addArrangedSubview(checkBoxButton)
        wholeAgreeStackView.addArrangedSubview(wholeAgreeLabel)
        wholeAgreeStackView.snp.makeConstraints { make in
            // top 임시값 세팅
            make.top.equalToSuperview().offset(80)
            make.trailing.leading.equalToSuperview().inset(30)
        }
        
        view.addSubview(wholeAgreeInformLabel)
        wholeAgreeInformLabel.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeStackView.snp.bottom).offset(10)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(dividingLineView)
        dividingLineView.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeInformLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }
        
        view.addSubview(wholeAgreeInformLabel)
        wholeAgreeInformLabel.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeStackView.snp.bottom).offset(10)
            make.leading.equalTo(wholeAgreeLabel.snp.leading)
        }
        
        view.addSubview(termsAgreeCheckBoxButton)
        termsAgreeCheckBoxButton.snp.makeConstraints { make in
            make.top.equalTo(wholeAgreeInformLabel.snp.bottom).offset(30)
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
