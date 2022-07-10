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
        $0.distribution = .fill
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setConstraints()
        setUpNotification()
        
        setupEndEditing()
    }
    
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }
    }
    
    private func setupEndEditing() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
}

extension BaseViewController {
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                  return
              }
        keyboardFrame = self.contentView.convert(keyboardFrame, from: nil)
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
}
