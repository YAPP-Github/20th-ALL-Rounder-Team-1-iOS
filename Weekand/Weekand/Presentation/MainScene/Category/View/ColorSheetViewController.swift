//
//  ColorSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit
import SnapKit
import Then

class ColorSheetViewController: BottomSheetViewController {
    
    var viewModel: ColorSheetViewModel?
    
    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = "색상"
    }
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        bottomSheetView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        bottomSheetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func configureUI() {
    }
    
    private func bindViewModel() {
        
    }

}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct ColorSheetViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ColorSheetViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
