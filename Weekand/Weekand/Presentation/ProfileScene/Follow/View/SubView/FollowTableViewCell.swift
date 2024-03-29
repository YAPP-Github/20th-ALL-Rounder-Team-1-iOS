//
//  FollowTableViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import UIKit

class FollowTableViewCell: UITableViewCell {

    static let cellIdentifier = "FollowTableViewCell"
    var dataId: String?
    
    lazy var cellStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }
    
    lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    lazy var contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.subHead2()
        $0.textColor = .gray900
    }
    
    lazy var goalLabel = UILabel().then {
        $0.font = WFont.body2()
        $0.textColor = .gray400
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
        setupView()
    }
    
    private func setupView() {
        self.selectionStyle = .none
    }
    
    private func configureUI() {
        
        self.addSubview(cellStack)
        
        cellStack.addArrangedSubview(profileImageView)
        cellStack.addArrangedSubview(contentStack)

        cellStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(69)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(cellStack.snp.width).multipliedBy(1/8.5)
            make.centerY.equalTo(cellStack.snp.centerY)
        }
        
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(goalLabel)
    }
    

}

extension FollowTableViewCell {
    
    public func setData(user: UserSummaryTemp) {
        
        self.dataId = user.userSummaryId
        nameLabel.text = user.name
        goalLabel.text = user.goal
        
        DispatchQueue.global().async {
            if let cachedImage = ImageCacheManager.shared.loadCachedData(for: user.imagePath) {
                DispatchQueue.main.async {
                    self.profileImageView.image = cachedImage
                }
            } else {
                guard let imageURL = URL(string: user.imagePath) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                guard let image = UIImage(data: imageData) else { return }
                
                ImageCacheManager.shared.setCacheData(of: image, for: user.imagePath)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
        
    }

}
