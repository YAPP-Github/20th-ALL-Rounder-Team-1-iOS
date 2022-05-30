//
//  WLeftIconLabel.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//  https://github.com/ChoiysApple/MVVMovie/blob/main/MovieApp/MovieApp/Presentation/DetailView/View/CustomView/IconLabel.swift
//

import UIKit
import SnapKit
import Then

class WIconLabel: UIView {
    
    lazy var icon = UIImageView().then {
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    lazy var label = UILabel().then {
        $0.textAlignment = .left
    }
    lazy var stack = UIStackView().then {
        
        $0.addArrangedSubview(icon)
        $0.addArrangedSubview(label)

        icon.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.width.equalTo(icon.snp.height)
        }
        
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
      self.addSubview(stack)
      
      stack.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct WIconLabelPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let label = WIconLabel()
            label.label.text = "This is Sample"
            label.icon.image = UIImage(systemName: "checkmark")
            return label
        }.previewLayout(.sizeThatFits)
    }
}
#endif
