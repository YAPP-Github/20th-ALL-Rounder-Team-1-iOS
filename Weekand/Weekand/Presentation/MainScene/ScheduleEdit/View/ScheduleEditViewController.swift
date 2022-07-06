//
//  ScheduleEditViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/04.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import DropDown
import FSCalendar

class ScheduleEditViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    var viewModel: ScheduleEditViewModel?
    
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
    lazy var addInformationContainerView = AddInformationContainerView()
    lazy var memoStackView = MemoStackView(placeholder: "메모를 입력해주세요", nameText: "메모")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "일정 추가"
        navigationItem.leftBarButtonItem = closeButton
        stackView.spacing = 25
        
        memoStackView.isHidden = true
        memoStackView.textView.delegate = self
        
        startDateTimeStackView.calendar.delegate = self
        startDateTimeStackView.calendar.dataSource = self
        
        dropDownStackView.dropDown.cellNib = UINib(nibName: "CategoryDropDownCell", bundle: nil)
        dropDownStackView.dropDown.dataSource = ["공부", "자기 계발", "업무"]
        let colorList: [Color] = [Color(id: 1, hexCode: "#FF9292"), Color(id: 2, hexCode: "#FFB27A"), Color(id: 3, hexCode: "#FFE600")]
        dropDownStackView.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CategoryDropDownCell else { return }
            
            cell.colorView.backgroundColor = UIColor(hex: colorList[index].hexCode)
        }
    }
    
    private func configureUI() {
        [
            nameStackView,
            dropDownStackView,
            startDateTimeStackView,
            endDateTimeStackView,
            memoStackView,
            addInformationContainerView
        ].forEach { stackView.addArrangedSubview($0) }
        
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
        let isSelectedStartDate = BehaviorRelay(value: false)
        let isSelectedStartTime = BehaviorRelay(value: false)
        let isSelectedEndDate = BehaviorRelay(value: false)
        let isSelectedEndTime = BehaviorRelay(value: false)
        
        isSelectedStartDate.asObservable()
            .bind(to: startDateTimeStackView.dateButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedStartTime.asObservable()
            .bind(to: startDateTimeStackView.timeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedEndDate.asObservable()
            .bind(to: endDateTimeStackView.dateButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedEndTime.asObservable()
            .bind(to: endDateTimeStackView.timeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        let input = ScheduleEditViewModel.Input(
            closeButtonDidTapEvent: closeButton.rx.tap.asObservable(),
            isSelectedStartDate: isSelectedStartDate,
            isSelectedStartTime: isSelectedStartTime,
            isSelectedEndDate: isSelectedEndDate,
            isSelectedEndTime: isSelectedEndTime,
            startDateButtonDidTapEvent: startDateTimeStackView.dateButton.rx.tap.asObservable(),
            startTimeButtonDidTapEvent: startDateTimeStackView.timeButton.rx.tap.asObservable(),
            endDateButtonDidTapEvent: endDateTimeStackView.dateButton.rx.tap.asObservable(),
            endTimeButtonDidTapEvent: endDateTimeStackView.timeButton.rx.tap.asObservable()
        )
        
        self.viewModel?.transform(input: input)
        
        
        dropDownStackView.arrowButton.rx.tap.subscribe(onNext: {
            self.dropDownStackView.dropDown.show()
        }).disposed(by: disposeBag)
        
        isSelectedStartDate.subscribe(onNext: { isSelected in
            UIView.transition(with: self.startDateTimeStackView.dateButton ?? UIButton(), duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.startDateTimeStackView.datePickerContainerView.alpha = 1
                    self.startDateTimeStackView.datePickerContainerView.isHidden = false
                } else {
                    self.startDateTimeStackView.datePickerContainerView.alpha = 0
                    self.startDateTimeStackView.datePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        isSelectedStartTime.subscribe(onNext: { isSelected in
            UIView.transition(with: self.startDateTimeStackView.timeButton ?? UIButton(), duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.startDateTimeStackView.timePickerContainerView.alpha = 1
                    self.startDateTimeStackView.timePickerContainerView.isHidden = false
                } else {
                    self.startDateTimeStackView.timePickerContainerView.alpha = 0
                    self.startDateTimeStackView.timePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        isSelectedEndDate.subscribe(onNext: { isSelected in
            UIView.transition(with: self.endDateTimeStackView.dateButton ?? UIButton(), duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.endDateTimeStackView.datePickerContainerView.alpha = 1
                    self.endDateTimeStackView.datePickerContainerView.isHidden = false
                } else {
                    self.endDateTimeStackView.datePickerContainerView.alpha = 0
                    self.endDateTimeStackView.datePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        isSelectedEndTime.subscribe(onNext: { isSelected in
            UIView.transition(with: self.endDateTimeStackView.timeButton ?? UIButton(), duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.endDateTimeStackView.timePickerContainerView.alpha = 1
                    self.endDateTimeStackView.timePickerContainerView.isHidden = false
                } else {
                    self.endDateTimeStackView.timePickerContainerView.alpha = 0
                    self.endDateTimeStackView.timePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        addInformationContainerView.memoButton.rx.tap.subscribe(onNext: {
            self.memoStackView.isHidden = false
            self.addInformationContainerView.memoButton.isHidden = true
        }).disposed(by: disposeBag)
    }
}

extension ScheduleEditViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}

extension ScheduleEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == memoStackView.textView.placeHolder {
            textView.text = nil
            textView.textColor = .gray900
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoStackView.textView.placeHolder
            textView.textColor = .gray400
        }
    }
}
