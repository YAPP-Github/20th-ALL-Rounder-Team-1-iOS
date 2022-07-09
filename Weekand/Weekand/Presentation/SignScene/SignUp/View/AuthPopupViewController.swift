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
import SwiftUI

class AuthPopupViewController: PopupViewController {
    
    // ViewMoel
    
    private let disposeBag = DisposeBag()
    var viewModel: AuthPopupViewModel?
    
    // Views
    
    lazy var titleLabel = WTextLabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
        $0.text = "안내"
    }
    
    lazy var textLabel = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray600
        $0.text = "인증번호가 발송되었습니다."
    }
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
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
        let input = AuthPopupViewModel.Input(
            confirmButtonDidTapEvent: self.confirmButton.rx.tap.asObservable()
        )
        
        let _ = viewModel?.transform(input: input)
    }
}

#if canImport(SwiftUI) && DEBUG

struct AuthPopupViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            AuthPopupViewController().showPreview(.iPhone8)
        }
    }
}
#endif
