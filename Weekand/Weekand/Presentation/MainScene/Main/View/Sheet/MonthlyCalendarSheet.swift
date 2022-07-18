//
//  MonthlyCalendarSheet.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import FSCalendar
import RxSwift

/// 월간 캘린더
class MonthlyCalendarSheetViewController: BottomSheetViewController {
    
    lazy var calendar = WCalendarView()
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    var viewModel: MonthlyCalendarSheetViewModel?
    let disposeBag = DisposeBag()
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 500
        }
    }
    
    init (currentDate: Date) {
        super.init(nibName: nil, bundle: nil)
        print("현재날짜: \(currentDate)")
        viewModel?.selectedDate = currentDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
        
        calendar.calendar.select(viewModel?.selectedDate)
    }
    
    private func setUpView() {
        calendar.calendar.delegate = self
    }
    
    private func configureUI() {
        [calendar, confirmButton].forEach { self.bottomSheetView.addSubview($0) }
        calendar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(36)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(40)
        }
        
    }
    
    private func bindViewModel() {
        
        let input = MonthlyCalendarSheetViewModel.Input(
            didTapConfirmButton: self.confirmButton.rx.tap.asObservable()
        )
        
        self.confirmButton.rx.tap.subscribe(onNext: { _ in
            print("dismiss")
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        _ = self.viewModel?.transform(input: input)
        
        
    }

}

extension MonthlyCalendarSheetViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel?.selectedDate = date
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel?.selectedDate = nil
    }
}
