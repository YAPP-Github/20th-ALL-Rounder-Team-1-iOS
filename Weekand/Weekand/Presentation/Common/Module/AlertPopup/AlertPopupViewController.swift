//
//  AlertPopupViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

class AlertPopupViewController: PopupViewController {
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: AlertPopupViewModel?
    
    // Views
    
    lazy var titleLabel = WTextLabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
    }
    
    lazy var textLabel = WMultiLineTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray600
        $0.numberOfLines = 0
    }
    
    lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    lazy var cancelButton = WDefaultButton(title: "", style: .tint, font: WFont.subHead1())
    lazy var confirmButton = WDefaultButton(title: "", style: .filled, font: WFont.subHead1())
    
    override var popupViewHeight: CGFloat {
        get {
            return 200
        }
    }
    
    var titleText: String
    var informText: String
    var confirmButtonText: String
    var cancelButtonText: String
    
    init(titleText: String,
         informText: String,
         confirmButtonText: String,
         cancelButtonText: String) {
        self.titleText = titleText
        self.informText = informText
        self.confirmButtonText = confirmButtonText
        self.cancelButtonText = cancelButtonText
        
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
    
    private func setupView() {
        self.titleLabel.text = titleText
        self.textLabel.setText(string: informText)
        self.confirmButton.setTitle(confirmButtonText, for: .normal, font: WFont.subHead1())
        self.cancelButton.setTitle(cancelButtonText, for: .normal, font: WFont.subHead1())
    }
    
    private func configureUI() {
        [titleLabel, textLabel, buttonStackView].forEach { popupStackView.addArrangedSubview($0) }
        
        [cancelButton, confirmButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func bindViewModel() {
        let input = AlertPopupViewModel.Input(
            confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable(),
            cancelButtonDidTapEvent: self.cancelButton.rx.tap.asObservable()
        )
        
        viewModel?.transform(input: input)
    }

}
