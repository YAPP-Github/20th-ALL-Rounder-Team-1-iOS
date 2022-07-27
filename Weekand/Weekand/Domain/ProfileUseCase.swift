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
}
