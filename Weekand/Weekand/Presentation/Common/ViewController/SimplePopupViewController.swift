//
//  AuthPopupViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SimplePopupViewController: PopupViewController {
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: SimplePopupViewModel?
    
    var titleText: String = "안내"
    var informText: String = ""
    
    // Views
    
    lazy var titleLabel = WTextLabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
        $0.text = titleText
    }
    
    lazy var textLabel = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray600
        $0.text = informText
    }
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    init(titleText: String, informText: String) {
        self.titleText = titleText
        self.informText = informText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() { }
    
    private func configureUI() {
        [titleLabel, textLabel, confirmButton].forEach { popupStackView.addArrangedSubview($0) }
    }
    
    private func bindViewModel() {
        let input = SimplePopupViewModel.Input(
            confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable()
        )
        
        let _ = viewModel?.transform(input: input)
    }
}
