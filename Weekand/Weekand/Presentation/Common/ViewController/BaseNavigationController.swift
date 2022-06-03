//
//  BaseNavigationController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/03.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance() {
        navigationBar.barTintColor = .gray700
        navigationBar.tintColor = .gray400
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray700,
            NSAttributedString.Key.font: UIFont(name: "PretendardVariable-Medium", size: 16)
        ]
    }
}
