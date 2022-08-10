//
//  ContactViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/24.
//

import Foundation
import RxSwift
import UIKit
import RxRelay

class ContactViewController: BaseViewController {
    
    var viewModel: ContactViewModel?
    private let disposeBag = DisposeBag()
    
    let placeholder = "내용을 입력해주세요."
    let maxCount = 500
    
    // MARK: Label
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.title()
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.text =
            """
            문의하실 내용을
            작성해주세요 :)
            """
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray500
        $0.text = "문의에 대한 답변은 로그인된 이메일로 전송됩니다."
    }
    
    lazy var labelStack = UIStackView().then {
        $0.spacing = 8
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // MARK: TextField
    lazy var textView = UITextView().then {
        $0.delegate = self
        
        $0.isScrollEnabled = false
        
        $0.layer.cornerRadius = defaultCornerRadius
        $0.backgroundColor = .gray200
        
        $0.font = WFont.body1()
        $0.textColor = .gray400
        $0.text = placeholder
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: Button
    lazy var bottomButton = WBottmButton(title: "문의하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        self.title = "문의하기"
        self.stackView.spacing = 32
        self.view.backgroundColor = .backgroundColor
    }
    
    private func configureUI() {
        [titleLabel, descriptionLabel].forEach { labelStack.addArrangedSubview($0) }
        [labelStack, textView].forEach { stackView.addArrangedSubview($0) }
        textView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(360)
        }
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
        }
        
        self.view.addSubview(bottomButton)
        bottomButton.enable(string: "문의하기")
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }

    }
    
    private func bindViewModel() {
        
        let input = ContactViewModel.Input(
            contactString: textView.rx.text.asObservable(),
            didButtonTap: bottomButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.serverResult.subscribe(onNext: { isSuccess in
            if !isSuccess {
                self.showToast(message: "잠시후 다시 시도해주세요")
            }
        }).disposed(by: disposeBag)
    }
}

extension ContactViewController: UITextViewDelegate {
    
    // Placeholder 지우기
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .gray900
        }
    }
    
    // Placeholder 생성
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .gray400
        }
    }
    
    // 글자수제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return textView.text.count - range.length + text.count > maxCount ? false : true
    }
    
}
