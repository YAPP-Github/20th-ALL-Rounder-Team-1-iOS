//
//  PopupViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import UIKit

class PopupViewController: UIViewController {

    lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    lazy var popupStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureUI()
    }
    
    private func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    private func configureUI() {
        view.addSubview(popupView)
        popupView.addSubview(popupStackView)

        popupView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(210)
            $0.centerX.centerY.equalToSuperview()
        }
        
        popupStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(24)
        }
    }
    
}
