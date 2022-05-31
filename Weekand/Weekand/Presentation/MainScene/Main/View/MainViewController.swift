//
//  MainViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "id")
        tableView.dataSource = self
        tableView.delegate = self
    }


}

// TODO: Refator to DiffableDataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id") as! MainTableViewCell
        cell.configureCell(color: .red, title: "\(indexPath.row). Title", status: .completed, time: "00:00 - 00:00")
        return cell
    }
    
}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            MainViewController().showPreview(.iPhone8)
            MainViewController().showPreview(.iPhone12Mini)
        }
    }
}
#endif
