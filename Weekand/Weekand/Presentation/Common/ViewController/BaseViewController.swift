//
//  BaseViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/24.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController {

    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setConstraints()
    }

    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

#if canImport(SwiftUI) && DEBUG

struct BaseViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            BaseViewController().showPreview(.iPhone8)
        }
    }
}
#endif
