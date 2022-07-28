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
    
    func userSummary(id: String?) -> Single<UserSummary?> {
        
        return NetWork.shared.fetch(query: UserSummaryQuery(id: id))
            .map {
                if let user = $0.user {
                    return UserSummary(model: user)
                } else {
                    return nil
                }
            }.asSingle()
    }
    
    func scheduleList(date: Date) -> Single<[ScheduleMain]> {
        return NetWork.shared
            .fetch(query: ScheduleListQuery(date: date.toTimestamp()))
            .map {
                $0.schedules.schedules.map {
                    ScheduleMain(model: $0)
                }
            }
            .asSingle()
    }
    
    func stickerSummary(id: String, date: Date) -> Single<StickerSummary> {
        return NetWork.shared.fetch(query: StickerSummaryQuery(id: id, date: date.toTimestamp()))
            .map {
                StickerSummary(model: $0.scheduleStickerSummary)
            }
            .asSingle()
    }
    
}
