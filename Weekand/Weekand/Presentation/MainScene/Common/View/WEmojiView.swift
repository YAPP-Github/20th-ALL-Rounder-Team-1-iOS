//
//  WEmojiView.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/31.
//

import UIKit
import SnapKit
import Then

enum Emoji {
    case good       // 좋아요
    case awesome    // 대단해요
    case cool       // 멋져요
    case support    // 응원해요
    
    var imageName: String {
        switch self {
        case .good:     return "SmileEmoji"
        case .awesome:  return "GoodEmoji"
        case .cool:     return "CoolEmoji"
        case .support:  return "CongratsEmoji"
        }
    }
}

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
        stackView.spacing = 9.5
    }
    
    private func setupView() {
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emojiStack.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(numberLabel)
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
    
    // Emoji를 배열로 받아 순서대로 표시해준다.
    // API가 [emojiName: emojiNumber] 형태로 전달해주면 추후에 emojiOrder 생성하는 함수 구현
    func setEmoji(emojiOrder: [Emoji]) {
        
        let imageViewSet = emojiStack.arrangedSubviews.reversed()
        let emojiSet = emojiOrder.reversed()
        
        for (view, emoji) in zip(imageViewSet, emojiSet) {
            
            guard let imageView = view as? UIImageView else { break }
            
            imageView.image = UIImage(named: emoji.imageName)
        }
        
    }
    
}
