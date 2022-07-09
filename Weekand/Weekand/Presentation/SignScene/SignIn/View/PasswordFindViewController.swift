//
//  PasswordFindViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import UIKit
import SnapKit
import Then
import RxSwift

class PasswordFindViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: PasswordFindViewModel?
    
    lazy var closeButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "close")
        $0.tintColor = .gray400
    }
    
    lazy var titleLabel = WTextLabel().then {
        $0.text = "비밀번호를\n잊으셨나요?"
        $0.font = WFont.title()
        $0.numberOfLines = 0
    }
    
    lazy var informLabel = WTextLabel().then {
        $0.text = "작성하신 이메일로 임시 비밀번호를 보내드려요.\n임시 비밀번호로 로그인하신 후에 \n계정관리에서 비밀번호를 변경해주세요."
        $0.font = WFont.subHead2()
        $0.textColor = .gray600
        $0.numberOfLines = 0
    }
    
    lazy var emailField = WTextField(placeHolder: "이메일을 입력해주세요")
    lazy var confirmButton = WDefaultButton(title: "임시비밀번호 발급", style: .filled, font: WFont.subHead1())
    
    lazy var textFieldStack = UIStackView().then {
        $0.addArrangedSubview(emailField)
        $0.addArrangedSubview(confirmButton)
        
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func configureUI() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.view.addSubview(informLabel)
        informLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.top.equalTo(informLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    private func bindViewModel() {
        let input = PasswordFindViewModel.Input(
            emailTextFieldDidEditEvent: emailField.rx.text.orEmpty.asObservable(),
            closeButtonDidTapEvent: closeButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
    }

}
