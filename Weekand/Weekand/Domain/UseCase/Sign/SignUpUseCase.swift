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
            .fetch(query: SendAuthKeyQuery(email: email), cachePolicy: .fetchIgnoringCacheCompletely, queue: DispatchQueue.main)
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
            .fetch(query: CheckDuplicateNicknameQuery(nickname: nickName), cachePolicy: .fetchIgnoringCacheCompletely, queue: DispatchQueue.main)
            .map { $0.checkDuplicateNickname }
            .asSingle()
    }
    
    func SignUp(signUpModel: SignUpModel) -> Single<Bool> {
        let signUpInput = SignUpInput(
                                email: signUpModel.email ?? "",
                                password: signUpModel.password ?? "",
                                nickname: signUpModel.nickname ?? "",
                                jobs: signUpModel.jobs,
                                interests: signUpModel.interests,
                                signUpAgreed: signUpModel.signUpAgreed ?? false
        )
        
        return NetWork.shared
            .perform(mutation: SignUpMutation(signUpInput: signUpInput))
            .map { $0.signUp }
            .asSingle()
    }
}
