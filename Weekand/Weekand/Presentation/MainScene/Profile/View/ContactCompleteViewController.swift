//
//  ContactCompleteViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import UIKit
import SnapKit
import Then

// 데이터 처리가 없는 뷰이기 때문에 ViewModel 생략
class ContactCompleteViewController: UIViewController {
    
    lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "SmileEmoji")
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = WFont.title()
        $0.textColor = .gray900
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = """
                문의가 정상적으로
                접수되었습니다!
                """
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray500
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.text = "문의에 대한 답변은 로그인된 이메일로 전송됩니다."
    }
    
    lazy var button = WDefaultButton(title: "프로필로 돌아가기", style: .filled, font: WFont.subHead1())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bind()
    }
    
    private func setUpView() {
        self.title = "문의하기"
    }
    
    private func configureUI() {
        [imageView, titleLabel, descriptionLabel, button].forEach { self.view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(125)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func bind() {
        
    }
}
