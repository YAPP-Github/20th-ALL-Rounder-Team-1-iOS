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

    var viewController: EmojiTabViewController
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 400
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    init(id: String, date: Date) {
        
        viewController = EmojiTabViewController(id: id, date: date)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
