//
//  InformationGroupStackView.swift
//  Weekand
//
//  Created by 이호영 on 2022/05/25.
//

import UIKit

class InformationGroupStackView: UIStackView {

    lazy var informationStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    lazy var namelabel = WTextLabel().then {
        $0.font = UIFont(name: "PretendardVariable-Medium", size: 15)
        $0.textColor = UIColor.gray800
    }
    
    lazy var informlabel = WTextLabel().then {
        $0.font = UIFont(name: "PretendardVariable-Medium", size: 13)
        $0.textColor = UIColor.gray500
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        spacing = 10
        informationStackView.spacing = 5
        
        [namelabel, informlabel].forEach { informationStackView.addArrangedSubview($0) }
        [informationStackView].forEach { self.addArrangedSubview($0) }
    }
    
    func setNameLabelText(string: String) {
        namelabel.text = string
    }
    
    func setInformlabelText(string: String) {
        informlabel.text = string
    }
}
