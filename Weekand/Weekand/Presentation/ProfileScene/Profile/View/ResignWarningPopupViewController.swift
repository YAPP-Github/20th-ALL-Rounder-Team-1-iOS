//
//  WarningPopupViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ResignWarningPopupViewController: PopupViewController {
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: WarningPopupViewModel?
    
    // Views
    
    lazy var titleLabel = WTextLabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
        $0.text = "잠깐!"
    }
    
    lazy var textLabel = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray600
        $0.text = "탈퇴 후에는 계정의 모든 정보가 삭제되며,\n삭제된 정보는 복구할 수 없어요.\n정말로 탈퇴하시겠습니까?"
        $0.numberOfLines = 0
    }
    
    lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    lazy var cancelButton = WDefaultButton(title: "아니요", style: .tint, font: WFont.subHead1())
    lazy var confirmButton = WDefaultButton(title: "탈퇴할게요", style: .filled, font: WFont.subHead1())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() { }
    
    private func configureUI() {
        [titleLabel, textLabel, buttonStackView].forEach { popupStackView.addArrangedSubview($0) }
        
        [cancelButton, confirmButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func bindViewModel() {
        let input = WarningPopupViewModel.Input(
            confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable(),
            cancelButtonDidTapEvent: self.cancelButton.rx.tap.asObservable()
        )
        
        let _ = viewModel?.transform(input: input)
    }
}
