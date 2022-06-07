//
//  CategoryViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/07.
//

import Foundation

class CategoryViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        
    }
    
    private func configureUI() {
        
    }
    
    private func bindViewModel() {
        
    }
}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct CategoryViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryViewController().showPreview(.iPhone8)
            CategoryViewController().showPreview(.iPhone12Mini)
        }
    }
}
#endif
