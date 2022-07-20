//
//  RepeatSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit

class RepeatSheetViewController: BottomSheetViewController {

    let viewController = RepeatTabViewController()
    
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
    
    private func setUpView() {
        
    }
    
    private func configureUI() {
        
        self.bottomSheetView.addSubview(viewController.view)
        viewController.view.clipsToBounds = true
        viewController.view.layer.cornerRadius = 27
        viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        viewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
    }
    
}
