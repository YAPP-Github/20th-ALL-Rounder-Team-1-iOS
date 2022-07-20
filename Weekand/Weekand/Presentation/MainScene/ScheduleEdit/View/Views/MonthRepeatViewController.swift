//
//  MonthRepeatViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit

class MonthRepeatViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
        bindViewModel()
    }
    
    
    private func setUpView() {
    }
    
    private func configureUI() {
    }
    
    private func bindViewModel() {
        
    }
}
