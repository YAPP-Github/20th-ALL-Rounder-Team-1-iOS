//
//  ProfileUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import Foundation
import RxSwift

final class ProfileUseCase {
    
    func profileDetail(id: String?) -> Single<UserDetail> {
        return NetWork.shared.fetch(query: UserDetailQuery(id: id))
            .map {
                if let userData = $0.user {
                    return UserDetail(model: userData)
                } else {
                    return UserDetail.defaultData
                }
                
            }.asSingle()
    }
    
    /// 유저 팔로우하기
    func createFollowee(id: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: CreateFolloweeMutation(id: id))
            .map { $0.createFollow }
            .asSingle()
    }
    
    /// 유저 팔로우 취소하기
    func deleteFollowee(id: String) -> Single<Bool> {
        return NetWork.shared.perform(mutation: DeleteFolloweeMutation(id: id))
            .map { $0.deleteFollowee }
            .asSingle()
    }
}
