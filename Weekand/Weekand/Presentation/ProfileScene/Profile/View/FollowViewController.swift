//
//  FollowViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/31.
//

import Foundation
import RxSwift
import SnapKit
import Then
import UIKit

class FollowViewController: UIViewController {
    
    var viewModel: FollowViewModel?
    private let disposeBag = DisposeBag()
    
    lazy var nameLabel = UILabel().then {
        $0.font = WFont.head2()
        $0.textColor = .mainColor
    }
    lazy var suffixLabel = UILabel().then {
        $0.font = WFont.head2()
        $0.textColor = .gray900
    }
    lazy var labelStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 0
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
