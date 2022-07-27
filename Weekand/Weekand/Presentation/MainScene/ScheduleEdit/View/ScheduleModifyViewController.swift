//
//  ScheduleModifyViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/26.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import FSCalendar
import DeveloperToolsSupport

class ScheduleModifyViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    var viewModel: ScheduleModifyViewModel?
    
    lazy var closeButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "close")
        $0.tintColor = .gray400
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("완료", for: .normal)
        $0.disable(string: "완료")
    }
    let nameStackView = WTextFieldStackView(fieldPlaceholder: "일정명을 입력해주세요.", nameText: "일정")
    let categoryStackView = CategoryStackView()
    lazy var calendarStackView = DateStackView(dateText: WDateFormatter.dateFormatter.string(from: Date()))
    lazy var timeStackView = TimeStackView(startTimeText: WDateFormatter.timeFormatter.string(from: defaultStartTime),
                                           endTimeText: WDateFormatter.timeFormatter.string(from: defaultEndTime))
    let addInformationContainerView = AddInformationContainerView()
    let repeatStackView = RepeatStackView()
    let memoStackView = MemoStackView(placeholder: "메모를 입력해주세요", nameText: "메모")
    
    var defaultStartTime: Date {
        let currentTime = Date()
        return currentTime
    }
    
    var defaultEndTime: Date {
        let currentTime = Date()
        let addedTime = Calendar.current.date(byAdding: .hour, value: 1, to: currentTime) ?? currentTime
        return addedTime
    }
    
    var category: Category?
    
    var repeatType: ScheduleRepeatType = .once {
        didSet {
            self.selectedRepeatType.accept(self.repeatType)
        }
    }
    
    var repeatSelectedValue: [ScheduleWeek] = [] {
        didSet {
            self.selectedRepeatSelectedValue.accept(self.repeatSelectedValue)
        }
    }
    
    var repeatEnd: Date? {
        didSet {
            self.selectedRepeatEnd.accept(self.repeatEnd)
        }
    }
    
    let isSelectedDate = BehaviorRelay(value: false)
    let isSelectedStartTime = BehaviorRelay(value: false)
    let isSelectedEndTime = BehaviorRelay(value: false)
    
    let selectedScheduleName = BehaviorRelay<String>(value: "")
    let selectedDate = BehaviorRelay<Date>(value: Date())
    let selectedStartTime = BehaviorRelay<Date>(value: Date())
    let selectedEndTime = BehaviorRelay<Date>(value: Date())
    let selectedCategory = BehaviorRelay<Category?>(value: nil)
    let selectedRepeatType = BehaviorRelay<ScheduleRepeatType>(value: .once)
    let selectedRepeatSelectedValue = BehaviorRelay<[ScheduleWeek]>(value: [])
    let selectedRepeatEnd = BehaviorRelay<Date?>(value: nil)
    let selectedMemo = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "일정 수정"
        navigationItem.leftBarButtonItem = closeButton
        stackView.spacing = 25
        
        repeatStackView.isHidden = true
        memoStackView.isHidden = true
        memoStackView.textView.delegate = self
    }
    
    private func configureUI() {
        [
            nameStackView,
            categoryStackView,
            calendarStackView,
            timeStackView,
            repeatStackView,
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
        bindDateTimeSelectView()
        bindRepeatView()
        bindEditView()
        
        let input = ScheduleModifyViewModel.Input(
            closeButtonDidTapEvent: closeButton.rx.tap.asObservable(),
            confirmButtonDidTapEvent: confirmButton.rx.tap.asObservable(),
            categoryArrowDidTapEvent: categoryStackView.arrowButton.rx.tap.asObservable(),
            isSelectedDate: isSelectedDate,
            isSelectedStartTime: isSelectedStartTime,
            isSelectedEndTime: isSelectedEndTime,
            dateButtonDidTapEvent: calendarStackView.dateButton.rx.tap.asObservable(),
            startTimeButtonDidTapEvent: timeStackView.startTimeButton.rx.tap.asObservable(),
            endTimeButtonDidTapEvent: timeStackView.endTimeButton.rx.tap.asObservable(),
            dateDidSelectEvent: calendarStackView.calendarView.calendar.rx.didSelect.asObservable(),
            repeatButtonDidTapEvent: addInformationContainerView.repeatButton.rx.tap.asObservable(),
            selectedScheduleName: selectedScheduleName,
            selectedDate: selectedDate,
            selectedStartTime: selectedStartTime,
            selectedEndTime: selectedEndTime,
            selectedCategory: selectedCategory,
            selectedRepeatType: selectedRepeatType,
            selectedRepeatSelectedValue: selectedRepeatSelectedValue,
            selectedRepeatEnd: selectedRepeatEnd,
            selectedMemo: selectedMemo
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.validNameInput.drive(onNext: { isValid in
            if isValid {
                self.confirmButton.enable(string: "완료")
            } else {
                self.confirmButton.disable(string: "완료")
            }
        }).disposed(by: disposeBag)
        
        self.viewModel?.defaultCategory
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] category in
                self?.categoryStackView.setCategory(category)
                self?.selectedCategory.accept(category)
        })
        .disposed(by: self.disposeBag)
        
        self.viewModel?.schedule
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] schedule in
                self?.selectedScheduleName.accept(schedule.name)
                self?.selectedDate.accept(schedule.dateStart)
                self?.selectedStartTime.accept(schedule.dateStart)
                self?.selectedDate.accept(schedule.dateEnd)
                self?.selectedStartTime.accept(schedule.dateStart)
                self?.selectedEndTime.accept(schedule.dateEnd)
                self?.selectedDate.accept(schedule.dateStart)
                self?.selectedRepeatType.accept(schedule.repeatType)
                self?.selectedRepeatEnd.accept(schedule.repeatEnd)
                
                if schedule.memo != "" {
                    self?.memoStackView.textView.text = schedule.memo
                    self?.memoStackView.isHidden = false
                }
                let dateString = WDateFormatter.dateFormatter.string(from: schedule.dateStart)
                self?.calendarStackView.dateButton.setTitle(dateString, for: .normal, font: WFont.body1())
                self?.calendarStackView.calendarView.calendar.select(schedule.dateStart)
                self?.selectedDate.accept(schedule.dateStart)
        })
        .disposed(by: self.disposeBag)
    }
    
    func bindDateTimeSelectView() {
        selectedStartTime.accept(defaultStartTime)
        selectedEndTime.accept(defaultEndTime)
        
        isSelectedDate.asObservable()
            .bind(to: timeStackView.startTimeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedStartTime.asObservable()
            .bind(to: timeStackView.startTimeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedEndTime.asObservable()
            .bind(to: timeStackView.endTimeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        isSelectedDate.subscribe(onNext: { isSelected in
            UIView.transition(with: self.calendarStackView.dateButton, duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.calendarStackView.calendarContainerView.alpha = 1
                    self.calendarStackView.calendarContainerView.isHidden = false
                } else {
                    self.calendarStackView.calendarContainerView.alpha = 0
                    self.calendarStackView.calendarContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        isSelectedStartTime.subscribe(onNext: { isSelected in
            UIView.transition(with: self.timeStackView.startTimeButton, duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.timeStackView.startTimePickerContainerView.alpha = 1
                    self.timeStackView.startTimePickerContainerView.isHidden = false
                } else {
                    self.timeStackView.startTimePickerContainerView.alpha = 0
                    self.timeStackView.startTimePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
        
        isSelectedEndTime.subscribe(onNext: { isSelected in
            UIView.transition(with: self.timeStackView.endTimeButton, duration: 0.3, options: .transitionCrossDissolve) {
                if isSelected {
                    self.timeStackView.endTimePickerContainerView.alpha = 1
                    self.timeStackView.endTimePickerContainerView.isHidden = false
                } else {
                    self.timeStackView.endTimePickerContainerView.alpha = 0
                    self.timeStackView.endTimePickerContainerView.isHidden = true
                }
            } completion: { _ in
                
            }
        }).disposed(by: disposeBag)
    }
    
    func bindEditView() {
        selectedScheduleName
            .bind(to: nameStackView.textField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        nameStackView.textField.rx.text.orEmpty.bind(to: selectedScheduleName)
            .disposed(by: disposeBag)
        
        calendarStackView.calendarView.calendar.rx.didSelect
            .subscribe(onNext: { [weak self] date in
                let dateString = WDateFormatter.dateFormatter.string(from: date)
                self?.calendarStackView.dateButton.setTitle(dateString, for: .normal, font: WFont.body1())
                self?.selectedDate.accept(date)
            })
            .disposed(by: disposeBag)
        
        selectedStartTime.bind(to: timeStackView.startTimePicker.rx.date)
            .disposed(by: disposeBag)
        
        timeStackView.startTimePicker.rx.date.bind(to: selectedStartTime)
            .disposed(by: disposeBag)
        
        selectedEndTime.bind(to: timeStackView.endTimePicker.rx.date)
            .disposed(by: disposeBag)
        
        timeStackView.endTimePicker.rx.date.bind(to: selectedEndTime)
            .disposed(by: disposeBag)
        
        selectedStartTime.subscribe(onNext: { [weak self] date in
            let selectedTime = WDateFormatter.timeFormatter.string(from: date)
            self?.timeStackView.startTimeButton.setTitle(selectedTime, for: .normal, font: WFont.body1())
        })
        .disposed(by: disposeBag)
        
        selectedEndTime.subscribe(onNext: { [weak self] date in
            let selectedTime = WDateFormatter.timeFormatter.string(from: date)
            self?.timeStackView.endTimeButton.setTitle(selectedTime, for: .normal, font: WFont.body1())
        })
        .disposed(by: disposeBag)

        addInformationContainerView.memoButton.rx.tap.subscribe(onNext: {
            self.memoStackView.isHidden = false
            self.addInformationContainerView.memoButton.isHidden = true
        }).disposed(by: disposeBag)
        
        selectedMemo
            .bind(to: memoStackView.textView.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindRepeatView() {
        Observable.combineLatest(selectedRepeatType, selectedRepeatEnd)
            .filter({ repeatType, _ in
                repeatType != .once
            })
            .subscribe(onNext: { [weak self] repeatType, repeatEndDate in
                let repeatText = WRepeatTextManager.combineTimeDate(repeatType: repeatType,
                                                                    repeatSelectedValue: nil,
                                                                    repeatEndDate: repeatEndDate)
                self?.repeatStackView.setRepeatText(repeatText)
                self?.repeatStackView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(selectedRepeatType, selectedRepeatSelectedValue, selectedRepeatEnd)
            .filter({ repeatType, _, _ in
                repeatType == .weekly
            })
            .subscribe(onNext: { [weak self] repeatType, repeatSelectedValue, repeatEndDate in
                let repeatText = WRepeatTextManager.combineTimeDate(repeatType: repeatType,
                                                                    repeatSelectedValue: repeatSelectedValue,
                                                                    repeatEndDate: repeatEndDate)
                self?.repeatStackView.setRepeatText(repeatText)
                self?.repeatStackView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TextView 

extension ScheduleModifyViewController: UITextViewDelegate {
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
