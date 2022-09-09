//
//  Filter.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import Foundation

enum ScheduleSort: CaseIterable {
    case dateCreatedDESC
    case dateCreatedASC
    case nameCreatedASC
    case nameCreatedDESC
    
    var description: String {
        switch self {
        case .dateCreatedDESC:
            return "최신순"
        case .dateCreatedASC:
            return "오래된순"
        case .nameCreatedASC:
            return "오름차순"
        case .nameCreatedDESC:
            return "내림차순"
        }
    }
}

extension ScheduleSort {
    func toModel() -> ScheduleCategorySort {
        switch self {
        case .dateCreatedASC:
            return ScheduleCategorySort.dateCreatedAsc
        case .dateCreatedDESC:
            return ScheduleCategorySort.dateCreatedDesc
        case .nameCreatedASC:
            return ScheduleCategorySort.nameAsc
        case .nameCreatedDESC:
            return ScheduleCategorySort.nameDesc
        }
    }
}
