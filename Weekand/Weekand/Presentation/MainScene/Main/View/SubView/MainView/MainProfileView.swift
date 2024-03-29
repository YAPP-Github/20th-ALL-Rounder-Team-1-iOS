//
//  MainProfileView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/06/20.
//

import UIKit

/// 메인 화면 프로필 부분 (이름, 한줄목표, 프로필 사진)
class MainProfileView: UIView {
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.subHead2()
        $0.textColor = .gray900
    }
    
    lazy var stateLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray400
    }
    
    lazy var labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.alignment = .leading
    }
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    lazy var parentStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func setupView() {
        
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 10
        self.isUserInteractionEnabled = true
    }
    
    private func configureUI() {
        
        [ nameLabel, stateLabel ].forEach { labelStack.addArrangedSubview($0) }
        [ labelStack, profileImageView ].forEach { parentStack.addArrangedSubview($0) }
        
        labelStack.setContentHuggingPriority(.required, for: .vertical)
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        self.addSubview(parentStack)
        parentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }

    /// raw data를 이용한 SetUp
    func setUpView(name: String, state: String, imagePath: String?) {
        
        profileImageView.image = UIImage(named: "default.person")
        
        nameLabel.text = name
        stateLabel.text = state
        
        if let imagePath = imagePath {
            DispatchQueue.global().async {
                if let cachedImage = ImageCacheManager.shared.loadCachedData(for: imagePath) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = cachedImage
                    }
                } else {
                    guard let imageURL = URL(string: imagePath) else { return }
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    guard let image = UIImage(data: imageData) else { return }
                    
                    ImageCacheManager.shared.setCacheData(of: image, for: imagePath)
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        }
        
    }
    
    /// Model을 이용한 setUp
    func setUpView(_ data: UserSummary) {
        setUpView(name: data.name, state: data.goal, imagePath: data.imagePath)
    }
    
}
