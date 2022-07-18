//
//  WFilterButtton.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/16.
//

import UIKit

class WFilterButtton: UIButton {

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
            configuration.background.backgroundColor = .gray100
            configuration.baseForegroundColor = .gray700
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 6)
            self.configuration = configuration
            
        } else {
            self.backgroundColor = .gray100
            self.setTitleColor(.gray700, for: .normal)
            self.clipsToBounds = true
            self.layer.cornerRadius = 8
            self.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 6)
        }
    }
    
    func setTitle(_ title: String?, _ count: Int?) {
        self.setTitle(title, for: .normal)
        
        guard let text = title else { return }
    
        let mutableAttributedString = NSMutableAttributedString()
            .normal(text, font: WFont.body3(), fontColor: .gray700)
        
        if let count = count {
            mutableAttributedString.normal(String(describing: count), font: WFont.body3(), fontColor: .mainColor)
        }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "chevron.down")
        imageAttachment.bounds = CGRect(x: 1, y: -6, width: 20, height: 20)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        mutableAttributedString.append(attachmentString)
        
        self.setAttributedTitle(mutableAttributedString, for: .normal)
        setUpView()
    }

}
