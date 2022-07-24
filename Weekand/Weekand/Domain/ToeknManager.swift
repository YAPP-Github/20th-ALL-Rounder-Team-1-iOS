//
//  UserDataManager.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Foundation
import RxSwift

class ToeknManager {
  
    static let shared = ToeknManager()
    private let disposeBag = DisposeBag()
  
    var accessToken: Token?
    var refreshToken: Token?
    
    func reissue(completion: @escaping (Result<Token, Error>) -> Void) {
        NetWork.shared.fetch(query: ReissueQuery())
            .subscribe(onNext: { result in
                let token = Token(value: result.reissue.accessToken, isExpired: false)
                ToeknManager.shared.accessToken = token
                completion(.success(token))
            }, onError: { error in
                completion(.failure(error))
            })
            .disposed(by: disposeBag)
    }
    
    private init() {}
}

struct Token {
    let value: String
    var isExpired: Bool
}
