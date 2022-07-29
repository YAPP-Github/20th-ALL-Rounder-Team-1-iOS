//
//  SignInUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/08.
//

import Foundation
import RxSwift

typealias Tokens = LoginQuery.Data.Login

final class SignInUseCase {
    
    func login(email: String, password: String) -> Single<Tokens> {
        return NetWork.shared
            .fetch(query: LoginQuery(email: email, password: password), cachePolicy: .fetchIgnoringCacheCompletely, queue: DispatchQueue.main)
            .map {
                Tokens(refreshToken: $0.login.refreshToken, accessToken: $0.login.accessToken)
            }
            .asSingle()
    }
    
    func issueTempPassword(email: String) -> Single<Bool> {
        return NetWork.shared
            .perform(mutation: IssueTempPasswordMutation(email: email))
            .map {
                $0.issueTempPassword
            }
            .asSingle()
    }
}
