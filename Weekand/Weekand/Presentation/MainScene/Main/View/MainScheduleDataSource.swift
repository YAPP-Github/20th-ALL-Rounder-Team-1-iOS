//
//  MainScheduleDataSource.swift
//  Weekand
//
//  Created by 이호영 on 2022/08/01.
//

import UIKit

class MainScheduleDataSource: UITableViewDiffableDataSource <MainSection, ScheduleMain> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
