//
//  SignUpUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import Foundation
import RxSwift

typealias AuthKey = SendAuthKeyQuery.Data

final class SignUpUseCase {
    
    func sendAuthKey(email: String) -> Single<AuthKey> {
        return NetWork.shared
            .fetch(query: SendAuthKeyQuery(email: email))
            .map { AuthKey(sendAuthKey: $0.sendAuthKey) }
            .asSingle()
    }
}
