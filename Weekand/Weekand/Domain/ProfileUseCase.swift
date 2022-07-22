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
                UserDetail(model: $0.user!)
            }.asSingle()
    }
}
