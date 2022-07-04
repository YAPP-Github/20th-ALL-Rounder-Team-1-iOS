//
//  ScheduleEditViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import Then
import SnapKit
import SwiftUI
import RxSwift
import RxCocoa

class ScheduleEditViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel?
    
    lazy var closeButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "close")
        $0.tintColor = .gray400
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("완료", for: .normal)
        $0.disable(string: "완료")
    }
    
    lazy var nameStackView = WTextFieldStackView(fieldPlaceholder: "일정명을 입력해주세요.", nameText: "일정")
    
    lazy var dropDownStackView = DropDownStackView()
    
    lazy var startDateTimeStackView = DateTimeStackView(nameText: "시작", dateText: "2022.05.22.", timeText: "16:00")
    lazy var endDateTimeStackView = DateTimeStackView(nameText: "종료", dateText: "2022.05.22.", timeText: "20:00")
    
    lazy var passwordStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호")
        $0.setInformlabelText(string: "숫자, 영어 조합 8자리 이상", informType: .normal)
        $0.setPlaceholderText(string: "비밀번호를 입력해주세요")
        $0.setSecureTextEntry()
        $0.hideTextFieldButton()
    }
    
    lazy var passwordCheckStackView = InputGroupStackView().then {
        $0.setNameLabelText(string: "비밀번호 확인")
        $0.setPlaceholderText(string: "비밀번호를 확인해주세요")
        $0.setSecureTextEntry()
        $0.hideTextFieldButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = closeButton
        stackView.spacing = 25
    }
    
    private func configureUI() {
        [nameStackView, dropDownStackView, startDateTimeStackView, endDateTimeStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(22)
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
    }
}
