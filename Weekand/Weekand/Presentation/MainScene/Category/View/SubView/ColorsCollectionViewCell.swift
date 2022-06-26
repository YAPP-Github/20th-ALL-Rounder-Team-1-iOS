//
//  ColorsCollectionViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/26.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "ColorsCell"
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                colorButton.layer.borderWidth = 2
                colorButton.layer.borderColor = UIColor.mainColor.cgColor
            } else {
                colorButton.layer.borderWidth = 0
            }
        }
    }
    
    lazy var colorButton = UIButton().then {
        $0.layer.cornerRadius = 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        contentView.addSubview(colorButton)
        colorButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
    
    private func setupView() { }

    public func configure(color: UIColor) {
        self.colorButton.backgroundColor = color
    }
}
