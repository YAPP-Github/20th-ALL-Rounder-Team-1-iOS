//
//  SignUpUseCase.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/09.
//

import Foundation
import RxSwift

final class SignUpUseCase {
    
    func sendAuthKey(email: String) -> Single<Bool> {
        return NetWork.shared
            .fetch(query: SendAuthKeyQuery(email: email))
            .map { $0.sendAuthKey }
            .asSingle()
    }
    
    func vaildAuthKey(key: String, email: String) -> Single<Bool> {
        return NetWork.shared
            .fetch(query: VaildAuthKeyQuery(authKey: key, email: email))
            .map { $0.validAuthKey }
            .asSingle()
    }
    
    func checkDuplicateNickname(nickName: String) -> Single<Bool> {
        return NetWork.shared
            .fetch(query: CheckDuplicateNicknameQuery(nickname: nickName))
            .map { $0.checkDuplicateNickname }
            .asSingle()
    }
}
