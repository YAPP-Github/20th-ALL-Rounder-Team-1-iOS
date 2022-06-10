//
//  WStatusTimeLabel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

enum StatusIcon: String {
    
    // TODO: 현재 임시로 SF Symbol 사용 -> ICON 완성되면 교체
    case upcoming = "sum"
    case proceeding = "arrowshape.turn.up.left"
    case completed = "checkmark"
    case skipped = "xmark"
    
    case start = "startDate"
    case end = "endDate"
}

class WStatusTimeLabel: WIconLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.label.font = WFont.body2()
        self.label.textColor = .gray400
    }
    
    init(status: StatusIcon, title: String) {
        super.init(frame: CGRect.zero)
        
        setupView()
        editValue(status: status, title: title)
    }
        
}

extension WStatusTimeLabel {
    
    public func editValue(status: StatusIcon, title: String) {
        
        self.icon.image = UIImage(systemName: status.rawValue)!
        self.icon.tintColor = .gray400  // TODO: 해당 코드 ICON으로 교체되면 삭제 예정
        self.label.text = title
    }
}

extension WStatusTimeLabel {
    
    // 임시
    public func configureValue(status: StatusIcon, title: String) {
        self.icon.image = UIImage(named: status.rawValue)!.withTintColor(.gray400)
        self.label.text = title
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct WStatusTimeLabelPreview: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            UIViewPreview {
                return WStatusTimeLabel(status: .completed, title: "00:00 - 00:00")
            }.previewLayout(.sizeThatFits).previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
#endif
