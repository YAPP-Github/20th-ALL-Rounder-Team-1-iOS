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
    
    lazy var nameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 10
    }
    
    lazy var nameLabel = WTextLabel().then {
        $0.font = WFont.head1()
        $0.textColor = .gray900
        $0.numberOfLines = 0
    }
    
    lazy var categoryStackView = ScheduleCategoryStackView()
    
    lazy var dividerLine = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    lazy var informationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
    }
    
    lazy var dateStackView = ScheduleInformationStackView(title: "일자")
    lazy var timeStackView = ScheduleInformationStackView(title: "시간")
    lazy var repeatStackView = ScheduleInformationStackView(title: "반복")
    lazy var skipStackView = ScheduleInformationStackView(title: "스킵")
    lazy var memoStackView = ScheduleInformationStackView(title: "메모")
    
    let name = PublishRelay<String>()
    let date = PublishRelay<String>()
    let time = PublishRelay<String>()
    let category = PublishRelay<Category>()
    let repeatText = PublishRelay<String>()
    let skip = PublishRelay<[Date]?>()
    let memo = PublishRelay<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        stackView.spacing = 20
    }
    
    private func configureUI() {
        [nameStackView,
         dividerLine,
         informationStackView
        ].forEach { stackView.addArrangedSubview($0) }
        
        [nameLabel,
         categoryStackView
        ].forEach { nameStackView.addArrangedSubview($0) }
        
        [dateStackView,
         timeStackView,
         repeatStackView,
         skipStackView,
         memoStackView
        ].forEach { informationStackView.addArrangedSubview($0) }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-64)
            make.trailing.leading.equalToSuperview()
        }
        
        informationStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-22)
        }
    }
    
    private func bindViewModel() {
        
        self.name.bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.date.bind(to: dateStackView.textLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.time.bind(to: timeStackView.textLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.category.bind { category in
            self.categoryStackView.setCategory(category)
        }
        .disposed(by: disposeBag)
        
        self.repeatText.bind { repeatText in
            if repeatText != "" {
                self.repeatStackView.textLabel.text = repeatText
            } else {
                self.repeatStackView.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        self.skip.bind { skip in
            if let skip = skip,
               skip != [] {
                let skipText = skip.map({ date in
                    WDateFormatter.dateFormatter.string(from: date)
                }).joined(separator: "\n")
                self.skipStackView.textLabel.text = skipText
            } else {
                self.skipStackView.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        self.memo.bind { memoText in
            if memoText != "" {
                self.memoStackView.textLabel.text = memoText
            } else {
                self.memoStackView.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        let input = ScheduleDetailViewModel.Input(
        )

        let _ = viewModel?.transform(input: input)
        
        self.viewModel?.schedule.subscribe(onNext: { [weak self] schedule in
            let repeatText = WRepeatTextManager.combineTimeDate(repeatType: schedule.repeatType,
                                                                repeatSelectedValue: schedule.repeatSelectedValue, repeatEndDate: schedule.repeatEnd)
            self?.navigationItem.title = schedule.name
            self?.name.accept(schedule.name)
            self?.category.accept(schedule.category)
            self?.date.accept(WDateFormatter.dateFormatter.string(from: schedule.dateStart))
            self?.time.accept(WDateFormatter.combineTimeDate(startTime: schedule.dateStart,
                                                             endTime: schedule.dateEnd))
            self?.repeatText.accept(repeatText)
            self?.skip.accept(schedule.dateSkip)
            self?.memo.accept(schedule.memo)
        })
        .disposed(by: disposeBag)
    }
}
