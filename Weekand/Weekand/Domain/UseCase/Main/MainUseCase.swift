//
//  MainUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/15.
//

import Foundation
import RxSwift

final class MainUseCase {
    
    /// 알람 목록
    func notification(page: Int, size: Int) -> Single<[Alarm]> {
        return NetWork.shared.fetch(query: NotificationQuery(page: page, size: size))
            .map {
                $0.notifications.notifications.map {
                    Alarm(id: $0.id, message: $0.message, type: $0.type.rawValue)
                }
            }
            .asSingle()
    }
    
    /// 내가 팔로우하는 유저 목록
    func followees(page: Int, size: Int) -> Single<[FollowingUser]> {
        return NetWork.shared.fetch(query: FolloweesQuery(page: page, size: size))
            .map {
                $0.followees.followees.map { FollowingUser(model: $0) }
            }.asSingle()
    }
    
    /// 메인에 표시되는 유저 정보
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
    
    /// 일정 리스트
    func scheduleList(date: Date, id: String?) -> Single<[ScheduleMain]> {
        return NetWork.shared
            .fetch(query: ScheduleListQuery(date: date.toTimestamp(), id: id), cachePolicy: .fetchIgnoringCacheCompletely)
            .map {
                $0.schedules.schedules.map {
                    ScheduleMain(model: $0)
                }
            }
            .asSingle()
    }
    
    /// 스티커 정보
    func stickerSummary(id: String, date: Date) -> Single<StickerSummary> {
        return NetWork.shared.fetch(query: StickerSummaryQuery(id: id, date: date.toTimestamp()))
            .map {
                StickerSummary(model: $0.scheduleStickerSummary)
            }
            .asSingle()
    }
    
    /// 스티커 추가
    func createSticker(id: String, sticker: Emoji, date: Date) -> Single<Bool> {
        
        guard let scheduleSticker = ScheduleStickerName(rawValue: sticker.rawValue) else {
            return Single<Bool>.just(false)
        }
        
        return NetWork.shared.perform(mutation: CreateStickerMutation(id: id, sticker: scheduleSticker, date: date.toTimestamp())).map { $0.createScheduleSticker }
            .asSingle()
    }
    
    // 일정 완전 삭제
    
    func deleteSchedule(scheduleId: String) -> Single<Bool> {
        NetWork.shared.perform(mutation: DeleteScheduleMutation(scheduleId: scheduleId))
            .map { $0.deleteSchedule }
            .asSingle()
    }
    
    // 이후 일정 삭제
    
    func deleteScheduleFromDate(scheduleId: String, requestDate: Date) -> Single<Bool> {
        NetWork.shared.perform(mutation: DeleteScheduleFromDateMutation(scheduleId: scheduleId, date: requestDate.toTimestamp()))
            .map { $0.deleteScheduleFromDate }
            .asSingle()
    }
    
    // 일정 스킵
    
    func skipSchedule(scheduleId: String, requestDate: Date) -> Single<Bool> {
        NetWork.shared.perform(mutation: SkipScheduleMutation(scheduleId: scheduleId, date: requestDate.toTimestamp()))
            .map { $0.skipSchedule }
            .asSingle()
    }
    
}
