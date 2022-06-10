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
}
