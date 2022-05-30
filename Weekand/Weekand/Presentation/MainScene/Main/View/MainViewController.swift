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

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.dataSource = self
    }


}

// TODO: Refator to DiffableDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id") as! UITableViewCell
//        cell.configureCell(color: .red, title: "\(indexPath.row). Title", status: .completed, time: "00:00 - 00:00")
//        cell.backgroundColor = .magenta
        cell.textLabel!.text = "title"
        return cell
    }
    
    
}
