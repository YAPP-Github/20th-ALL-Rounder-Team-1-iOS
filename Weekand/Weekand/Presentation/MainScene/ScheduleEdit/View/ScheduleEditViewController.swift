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
import FSCalendar
import DeveloperToolsSupport

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
    
    var category: Category? {
        didSet {
            // TODO: forced optional
            self.categoryStackView.setCategory(self.category!)
            self.selectedCategory.accept(self.category!)
        }
    }
    
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
    
    let selectedDate = BehaviorRelay<Date>(value: Date())
    let selectedStartTime = BehaviorRelay<Date>(value: Date())
    let selectedEndTime = BehaviorRelay<Date>(value: Date())
    let selectedCategory = BehaviorRelay<Category?>(value: nil)
    let selectedRepeatType = BehaviorRelay<ScheduleRepeatType>(value: .once)
    let selectedRepeatSelectedValue = BehaviorRelay<[ScheduleWeek]>(value: [])
    let selectedRepeatEnd = BehaviorRelay<Date?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
        setCategory()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "일정 추가"
        navigationItem.leftBarButtonItem = closeButton
        stackView.spacing = 25
        
        repeatStackView.isHidden = true
        memoStackView.isHidden = true
        memoStackView.textView.delegate = self
        
        timeStackView.startTimePicker.setDate(defaultStartTime, animated: false)
        timeStackView.startTimePicker.addTarget(self, action: #selector(startTimePickerValueDidChange(_:)), for: .valueChanged)
        timeStackView.endTimePicker.setDate(defaultEndTime, animated: false)
        timeStackView.endTimePicker.addTarget(self, action: #selector(endTimePickerValueDidChange(_:)), for: .valueChanged)
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
        bindDateTimeView()
        
        Observable.zip(selectedRepeatType, selectedRepeatEnd)
            .filter({ repeatType, _ in
                repeatType != .once
            })
            .subscribe(onNext: { [weak self] repeatType, repeatEndDate in
                var repeatText = ""
                if let date = repeatEndDate {
                    let dateString = WDateFormatter.dateFormatter.string(from: date) ?? ""
                    repeatText = "\(dateString)까지 \(repeatType.description)"
                } else {
                    repeatText = "\(repeatType.description)"
                }
                
                self?.repeatStackView.setRepeatText(repeatText)
                self?.repeatStackView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        Observable.zip(selectedRepeatType, selectedRepeatSelectedValue, selectedRepeatEnd)
            .filter({ repeatType, _, _ in
                repeatType == .weekly
            })
            .subscribe(onNext: { [weak self] repeatType, repeatSelectedValue, repeatEndDate in
                var repeatText = ""
                let repeatSelectedValueText = repeatSelectedValue.map { $0.description }.joined(separator: ",")
                if let date = repeatEndDate {
                    let dateString = WDateFormatter.dateFormatter.string(from: date) ?? ""
                    repeatText = "\(dateString)까지 \(repeatType.description) \(repeatSelectedValueText)"
                } else {
                    repeatText = "\(repeatType.description) \(repeatSelectedValueText)"
                }
                self?.repeatStackView.setRepeatText(repeatText)
                self?.repeatStackView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        let input = ScheduleEditViewModel.Input(
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
            nameTextFieldDidEditEvent: nameStackView.textField.rx.text.asObservable(),
            selectedDate: selectedDate,
            selectedStartTime: selectedStartTime,
            selectedEndTime: selectedEndTime,
            selectedCategory: selectedCategory,
            selectedRepeatType: selectedRepeatType,
            selectedRepeatSelectedValue: selectedRepeatSelectedValue,
            selectedRepeatEnd: selectedRepeatEnd,
            memoTextViewDidEditEvent: memoStackView.textView.rx.text.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.validNameInput.drive(onNext: { isValid in
            if isValid {
                self.confirmButton.enable(string: "완료")
            } else {
                self.confirmButton.disable(string: "완료")
            }
        }).disposed(by: disposeBag)
        
        output?.dateDidSelectEvent.drive(onNext: { date in
            let dateString = WDateFormatter.dateFormatter.string(from: date)
            self.calendarStackView.dateButton.setTitle(dateString, for: .normal, font: WFont.body1())
            self.selectedDate.accept(date)
        }).disposed(by: disposeBag)

        addInformationContainerView.memoButton.rx.tap.subscribe(onNext: {
            self.memoStackView.isHidden = false
            self.addInformationContainerView.memoButton.isHidden = true
        }).disposed(by: disposeBag)
        
        self.viewModel?.defaultCategory
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] category in
                self?.category = category
        })
        .disposed(by: self.disposeBag)
    }
    
    func bindDateTimeView() {
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
}

extension ScheduleEditViewController {
    @objc private func startTimePickerValueDidChange(_ datePicker: UIDatePicker) {
        let selectedTime = WDateFormatter.timeFormatter.string(from: datePicker.date)
        self.timeStackView.startTimeButton.setTitle(selectedTime, for: .normal, font: WFont.body1())
        self.selectedStartTime.accept(datePicker.date)
    }
    
    @objc private func endTimePickerValueDidChange(_ datePicker: UIDatePicker) {
        let selectedTime = WDateFormatter.timeFormatter.string(from: datePicker.date)
        self.timeStackView.endTimeButton.setTitle(selectedTime, for: .normal, font: WFont.body1())
        self.selectedDate.accept(datePicker.date)
    }
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

extension ScheduleEditViewController {
    func setCategory() {
        self.viewModel?.searchCategories()
    }
}
