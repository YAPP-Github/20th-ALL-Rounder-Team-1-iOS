//
//  PasswordChangeViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class PasswordChangeViewController: BaseViewController {
    
    var viewModel: PasswordChangeViewModel?
    private let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .backgroundColor
    }
    
    private func configureUI() {
        
    }
    
    private func bindViewModel() {
        
    }
}
