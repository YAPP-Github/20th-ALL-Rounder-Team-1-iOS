//
//  RepeatTableViewCell.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/21.
//

import UIKit

class RepeatTableViewCell: UITableViewCell {

    static let cellIdentifier = "RepeatCell"
    
    lazy var cellStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }
    
    lazy var radioView = UIImageView().then {
        $0.image = UIImage(named: "radio.disabled")!.withTintColor(.gray300)
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
    }

    lazy var dateLabel = UILabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            radioView.image = UIImage(named: "radio.enabled")!.withTintColor(.wblue)
        } else {
            radioView.image = UIImage(named: "radio.disabled")!.withTintColor(.gray300)
        }
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
    
    private func setupView() { }
    
    private func configureUI() {
        
        self.addSubview(cellStack)
        
        cellStack.addArrangedSubview(radioView)
        cellStack.addArrangedSubview(nameLabel)

        cellStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        radioView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
    
    public func configure(text: String) {
        nameLabel.text = text
    }
    
}
