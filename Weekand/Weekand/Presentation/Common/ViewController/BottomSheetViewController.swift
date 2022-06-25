//
//  BottomSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit
import SnapKit
import Then

class BottomSheetViewController: UIViewController {
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    var bottomSheetHeight: CGFloat = 300
    
    lazy var dimmedBackView = UIView().then {
        $0.backgroundColor?.withAlphaComponent(0.5)
    }

    lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 27
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        setUpGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    private func setupView() {
        dimmedBackView.alpha = 0.0
    }
    
    private func configureUI() {
        view.addSubview(dimmedBackView)
        dimmedBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomSheetView)
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        bottomSheetView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(bottomSheetHeight)
        }
    }
    
    func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomSheetHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    func hideBottomSheet() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setUpGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTap(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func dimmedViewTap(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheet()
    }
    
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheet()
            default:
                break
            }
        }
    }
    
}
