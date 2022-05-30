//
//  WStatusTimeLabel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

enum StatusIcon: String {
    
    case upcoming = "sum"
    case proceeding = "arrowshape.turn.up.left"
    case completed = "checkmark"
    case skipped = "xmark"
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
        self.icon.image = UIImage(systemName: status.rawValue)!.withTintColor(.lightGray!)
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
