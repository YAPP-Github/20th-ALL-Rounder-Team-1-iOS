//
//  MonthlyCalendarSheet.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit

/// 월간 캘린더
class MonthlyCalendarSheetViewController: BottomSheetViewController {
    
    lazy var calendar = WCalendarView()
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 500
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    private func setUpView() {
        
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

}
