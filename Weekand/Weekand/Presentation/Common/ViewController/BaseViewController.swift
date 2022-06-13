//
//  BaseViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/24.
//

import UIKit
import SwiftUI
import Then

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
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
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
