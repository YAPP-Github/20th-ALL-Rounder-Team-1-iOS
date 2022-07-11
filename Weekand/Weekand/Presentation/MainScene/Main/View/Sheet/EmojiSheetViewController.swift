//
//  EmojiSheetViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/07.
//

import UIKit
import SnapKit

/// 스티커 현황
class EmojiSheetViewController: BottomSheetViewController {

    let viewController = EmojiTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    private func setUpView() {
        
    }
    
    private func configureUI() {
        
        self.bottomSheetView.addSubview(viewController.view)
        viewController.view.clipsToBounds = true
        viewController.view.layer.cornerRadius = 27
        viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        viewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
}
