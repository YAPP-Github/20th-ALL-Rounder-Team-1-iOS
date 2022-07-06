//
//  APIService.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/30.
//

import Foundation
import RxSwift
import Apollo

enum ApolloError: Error {
    case partError
    case fetchError
}

class APIService {
    
    static func fetchRequest(query: Any, onComplete: @escaping (Result<GraphQLResult<WeekandQuery.Data>, Error>) -> Void) {

        Network.shared.apollo.fetch(query: WeekandQuery()) { result in
          switch result {
          case .success(let graphQLResult):
              print("Success! Result: \(#function)")
              onComplete(.success(graphQLResult))
              return
          case .failure(let error):
              print("Failure! Error: \(error)")
              onComplete(.failure(error))
              return
          }
        }
        
        
    }
    
    static func fetchResult(query: Any) -> Observable<String> {
        return Observable.create { emitter in

            fetchRequest(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    
                    if let helloText = graphQLResult.data?.weekand.hello {
                        emitter.onNext(helloText)
                        emitter.onCompleted()
                        
                        return
                    }
                  
                    if let errors = graphQLResult.errors {
                        print("GraphQL Error(s): \(errors)")
                        emitter.onError(ApolloError.partError)
                        return
                    }
                    
                case .failure(let error):
                    emitter.onError(error)
                }
                
            }
        
            return Disposables.create()
        }
    }
}
