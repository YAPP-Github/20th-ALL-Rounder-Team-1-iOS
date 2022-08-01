//
//  WEmojiView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/31.
//

import UIKit
import SnapKit
import Then

class WEmojiView: UIView {
    
    // MARK: 받은 Emoji 개수 label
    lazy var numberLabel = UILabel().then {
        $0.font = WFont.body3()
        $0.text = "0"
        $0.textColor = .gray400
        
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    // MARK: 받은 Emoji 종류
    lazy var emoji1 = WSquareImageView()
    lazy var emoji2 = WSquareImageView()
    lazy var emoji3 = WSquareImageView()
    lazy var emoji4 = WSquareImageView()
    
    lazy var emojiStack = UIStackView().then { stackView in
        [emoji1, emoji2, emoji3, emoji4].forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = -4
    }
    
    lazy var stackView = UIStackView().then { stackView in
        [numberLabel, emojiStack].forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
    }
    
    private func setupView() {
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emojiStack.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(19)
        }
        
    }

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
}

// MARK: EmojiStack
extension WEmojiView {
    
    /// Emoji를 배열로 받아 순서대로 표시해준다.
    func setEmoji(emojiOrder: [Emoji]) {
    
        stackView.spacing = 9.5 - CGFloat((4 - emojiOrder.count) * 15)

        let imageViewSet = emojiStack.arrangedSubviews.reversed()
        let emojiSet = emojiOrder.reversed()
        
        for view in imageViewSet {
            (view as? UIImageView)?.image = nil
        }
        
        for (view, emoji) in zip(imageViewSet, emojiSet) {
            
            guard let imageView = view as? UIImageView else { break }
            
            imageView.image = UIImage(named: emoji.imageName)
        }
        
    }
    
}
