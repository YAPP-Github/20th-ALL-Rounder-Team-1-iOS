//
//  ProfileUseCase.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/22.
//

import Foundation
import RxSwift

final class ProfileUseCase {
    
    func myProfileDetail() -> Single<UserDetail> {
        return NetWork.shared.fetch(query: MyUserDetailQuery())
            .map {
                if let userData = $0.user {
                    return UserDetail(model: userData)
                } else {
                    return UserDetail.defaultData
                }
                
            }.asSingle()
    }
}
