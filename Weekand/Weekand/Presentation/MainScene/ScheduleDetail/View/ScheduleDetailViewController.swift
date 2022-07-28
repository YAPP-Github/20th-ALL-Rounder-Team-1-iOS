//
//  ScheduleDetailViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class ScheduleDetailViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    var viewModel: ScheduleDetailViewModel?
    
    lazy var nameLabel = WTextLabel().then {
        $0.text = "Yapp 20기 회의"
        $0.font = WFont.head1()
        $0.textColor = .gray900
    }
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    lazy var informationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    lazy var dateStackView = ScheduleInformationStackView(title: "일자", text: "2022.05.22.")
    lazy var timeStackView = ScheduleInformationStackView(title: "시간", text: "10:00 - 21:00")
    lazy var repeatStackView = ScheduleInformationStackView(title: "반복", text: "매월 7일 반복")
    lazy var skipStackView = ScheduleInformationStackView(title: "스킵", text: "2022.05.22.")
    lazy var memoStackView = ScheduleInformationStackView(title: "메모", text:  "“뭘 써야 할지 모르겠어요.” 글쓰기 모임 첫날, 어떤 분이 이런 말을 한 적이 있다. 여태껏 글을 쓸 일이 없었기 때문에 막상 글을 쓰려니 뭘 써야 하나 막막하다는 것이다. 책방에 모여 한 시간 반 동안 각자 쓰고 싶은 글을 쓴 뒤에 그날 어떤 글을 썼는지 간략히 나누고 헤어지는 모임이었다. ")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "일정 제목"
    }
    
    private func configureUI() {
        [
            nameLabel,
            dividerLine,
            informationStackView
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            dateStackView,
            timeStackView,
            repeatStackView,
            skipStackView,
            memoStackView
        ].forEach { informationStackView.addArrangedSubview($0) }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-64)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        
        let input = ScheduleDetailViewModel.Input(
        )

        let _ = viewModel?.transform(input: input)
    }
}
