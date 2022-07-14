//
//  Filter.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/27.
//

import Foundation

enum ScheduleSort: CaseIterable {
    case dateCreatedASC
    case dateCreateDESC
    case nameCreatedASC
    case nameCreateDESC
    
    var description: String {
        switch self {
        case .dateCreatedASC:
            return "최신순"
        case .dateCreateDESC:
            return "오래된순"
        case .nameCreatedASC:
            return "오름차순"
        case .nameCreateDESC:
            return "내림차순"
        }
    }
}

extension ScheduleSort {
    func toModel() -> ScheduleCategorySort {
        switch self {
        case .dateCreatedASC:
            return ScheduleCategorySort.dateCreatedAsc
        case .dateCreateDESC:
            return ScheduleCategorySort.dateCreatedDesc
        case .nameCreatedASC:
            return ScheduleCategorySort.nameAsc
        case .nameCreateDESC:
            return ScheduleCategorySort.nameDesc
        }
    }
}
