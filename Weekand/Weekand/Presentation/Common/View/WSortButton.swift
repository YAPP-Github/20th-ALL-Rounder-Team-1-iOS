//
//  WFilterButton.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/10.
//

import UIKit

class WSortButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView() {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.background.backgroundColor = .white
            configuration.baseForegroundColor = .gray700
            configuration.background.cornerRadius = defaultCornerRadius
            configuration.contentInsets = NSDirectionalEdgeInsets.defaultEdgeInset
            self.configuration = configuration
            
        } else {
            self.layer.cornerRadius = defaultCornerRadius
            self.backgroundColor = .white
            self.setTitleColor(.gray700, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets.defaultEdgeInset
        }
    }
    
    func setTitle(_ title: String?) {
        self.setTitle(title, for: .normal)
        
        guard let text = title else { return }
        let mutableAttributedString = NSMutableAttributedString()
        
        let attribute = [NSAttributedString.Key.font: WFont.body3(),
                         NSAttributedString.Key.foregroundColor: UIColor.gray700]
        let attributedTitle = NSAttributedString(string: text, attributes: attribute as [NSAttributedString.Key: Any])
        
        mutableAttributedString.append(attributedTitle)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "arrow.down")
        imageAttachment.bounds = CGRect(x: 1, y: -6, width: 20, height: 20)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        mutableAttributedString.append(attachmentString)
        
        self.setAttributedTitle(mutableAttributedString, for: .normal)
    }

}
