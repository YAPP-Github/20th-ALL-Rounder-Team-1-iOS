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

    var isExpired: Bool = true
    
    private init() {}
    
    func reissue(completion: @escaping (Result<String, Error>) -> Void) {
        NetWork.shared.fetch(query: ReissueQuery())
            .subscribe(onNext: { result in
                let accessToken = result.reissue.accessToken
                ToeknManager.shared.setAccessToken(accessToken)
                completion(.success(accessToken))
            }, onError: { error in
                completion(.failure(error))
            })
            .disposed(by: disposeBag)
    }
    
    func createTokens(accessToken: String, refreshToken: String) {
        do {
            try KeyChainManager.shared.create(account: .accessToken,
                                              data: accessToken)
            try KeyChainManager.shared.create(account: .refreshToken,
                                              data: refreshToken)
            self.isExpired = false
        } catch {
            print(error)
        }
    }
    
    func setAccessToken(_ accessToken: String) {
        do {
            try KeyChainManager.shared.create(account: .accessToken,
                                          data: accessToken)
            self.isExpired = false
        } catch {
            print(error)
        }
    }
    
    func readAccessToken() -> String? {
        do {
            let accessToken = try KeyChainManager.shared.read(account: .accessToken)
            return accessToken
        } catch {
            print(error)
            return nil
        }
    }
    
    func readRefreshToken() -> String? {
        do {
            let refreshToken = try KeyChainManager.shared.read(account: .refreshToken)
            return refreshToken
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteTokens() {
        do {
            try KeyChainManager.shared.delete(account: .accessToken)
            try KeyChainManager.shared.delete(account: .refreshToken)
        } catch {
            print(error)
        }
    }
    
}
