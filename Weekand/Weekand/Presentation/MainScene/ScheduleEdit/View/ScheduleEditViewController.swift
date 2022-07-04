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
    
    lazy var addInformationStackView = AddInformationContainerView()
    
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
        [nameStackView, dropDownStackView, startDateTimeStackView, endDateTimeStackView, addInformationStackView].forEach { stackView.addArrangedSubview($0) }
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
        
        dropDownStackView.arrowButton.rx.tap.subscribe(onNext: {
            self.dropDownStackView.dropDown.show()
        }).disposed(by: disposeBag)
        
        startDateTimeStackView.timeButton.rx.tap
            .scan(false) { lastState, newState in !lastState }
            .subscribe(onNext: { [weak self] isSelect in
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCrossDissolve) {
                    if isSelect {
                        self?.startDateTimeStackView.timePicker.isHidden = false
                    } else {
                        self?.startDateTimeStackView.timePicker.isHidden = true
                    }
                } completion: { _ in
                    //
                }

            }).disposed(by: disposeBag)
        
        endDateTimeStackView.timeButton.rx.tap
            .scan(false) { lastState, newState in !lastState }
            .subscribe(onNext: { [weak self] isSelect in
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCrossDissolve) {
                    if isSelect {
                        self?.endDateTimeStackView.timePicker.isHidden = false
                    } else {
                        self?.endDateTimeStackView.timePicker.isHidden = true
                    }
                } completion: { _ in
                    //
                }

            }).disposed(by: disposeBag)
        
    }
}

extension ScheduleEditViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}
