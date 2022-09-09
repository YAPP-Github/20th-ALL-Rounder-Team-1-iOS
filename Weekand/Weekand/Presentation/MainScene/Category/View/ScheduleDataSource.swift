//
//  ScheduleSummaryDataSource.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import UIKit

class ScheduleSummaryDataSource: UITableViewDiffableDataSource <ScheduleSection, ScheduleSummary> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
