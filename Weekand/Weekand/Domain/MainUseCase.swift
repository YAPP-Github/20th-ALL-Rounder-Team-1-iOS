//
//  MainUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation
import RxSwift

final class MainUseCase {
    
    func scheduleList(date: Date) -> Single<[ScheduleMain]> {
        return NetWork.shared
            .fetch(query: ScheduleListQuery(date: date.toStringTimestamp()))
            .map {
                $0.schedules.schedules.map {
                    ScheduleMain(model: $0)
                }
            }
            .asSingle()
    }
}
