//
//  MainUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation
import RxSwift

final class MainUseCase {
    
    func followers(page: Int, size: Int) -> Single<[FollowingUser]> {
        return NetWork.shared.fetch(query: FollowersQuery(page: page, size: size))
            .map {
                $0.followers.followers.map { FollowingUser(model: $0) }
            }.asSingle()
    }
    
    func userSummary() -> Single<UserSummary> {
        return NetWork.shared.fetch(query: UserSummaryQuery())
            .map {
                if let user = $0.user {
                    return UserSummary(model: user)
                } else {
                    return UserSummary.defaultData
                }
            }
            .asSingle()
    }
    
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
