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
    case performError
    case graphQLErrors([GraphQLError])
}

class RxApolloClient {
    
    private let client: ApolloClient
    
    init(client: ApolloClient) {
        self.client = client
    }
    
    func fetch<Query: GraphQLQuery>(
            query: Query,
            cachePolicy: CachePolicy = .returnCacheDataElseFetch,
            queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Query.Data> {
        return Maybe.create { maybe in
            let cancellable = self.client.fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: nil, queue: queue) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors,
                       let error = errors.first {
                        maybe(.error(error))
                    } else if let data = graphQLResult.data {
                        maybe(.success(data))
                    } else {
                        maybe(.completed)
                    }
                case .failure(let error):
                    maybe(.error(error))
                }
            }
            
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
    func perform<Mutation: GraphQLMutation>(
            mutation: Mutation,
            publishResultToStore: Bool = true,
            queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Mutation.Data> {
        return Maybe.create { maybe in
            let cancellable = self.client.perform(
                mutation: mutation,
                publishResultToStore: publishResultToStore,
                queue: queue
            ) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors,
                       let error = errors.first {
                        maybe(.error(error))
                    } else if let data = graphQLResult.data {
                        maybe(.success(data))
                    } else {
                        maybe(.completed)
                    }
                case .failure(let error):
                    maybe(.error(error))
                }
            }
            
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}

extension ApolloClient {
    var rx: RxApolloClient { return RxApolloClient(client: self) }
}
