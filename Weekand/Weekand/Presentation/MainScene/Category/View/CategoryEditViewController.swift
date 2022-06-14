//
//  CategoryEditViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit
import Then

class CategoryEditViewController: BaseViewController {

    let categoryTextFieldStackView = WTextFieldStackView(fieldPlaceholder: "카테고리명", nameText: "카테고리")
    
    let openTypeStackView = OpenTypeStackView(nameText: "공개")
    
    lazy var colorStackView = ColorStackView(nameText: "색상").then {
        $0.setColor(.wred)
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("다음", for: .normal)
        $0.disable(string: "다음")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "카테고리 수정"
        stackView.spacing = 25
    }

    private func configureUI() {
        [categoryTextFieldStackView, openTypeStackView, colorStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            // top 임시값 세팅
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    private func bindViewModel() { }

}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct CategoryEditViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryEditViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif