//
//  UIVIewController+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/10.
//

import UIKit

extension UIViewController {
    func showActionSheet(
        titles: String,
        message: String,
        deleteHandler: @escaping (UIAlertAction) -> Void
    ) {
        let deleteAction = UIAlertAction(title: titles, style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showAlert(
        titles: String,
        message: String,
        deleteHandler: @escaping (UIAlertAction) -> Void
    ) {
        let deleteAction = UIAlertAction(title: titles, style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showActionSheet(
        titles: (String, String),
        message: String,
        deleteHandler: @escaping (UIAlertAction) -> Void,
        deleteAfterHandler: @escaping (UIAlertAction) -> Void
    ) {
        let deleteAction = UIAlertAction(title: titles.0, style: .destructive, handler: deleteHandler)
        let deleteAfterAction = UIAlertAction(title: titles.1, style: .destructive, handler: deleteAfterHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.addAction(deleteAction)
        alert.addAction(deleteAfterAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showToast(message: String) {
        let toastLabel = WToastLabel()
        let toastLabelFrame = CGRect(x: self.view.frame.size.width/2 - 163, y: self.view.frame.size.height - 145, width: 327, height: 48)
        toastLabel.setMessage(text: message, font: WFont.body1(), frame: toastLabelFrame)
        self.view.addSubview(toastLabel)
        self.view.endEditing(true)
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
