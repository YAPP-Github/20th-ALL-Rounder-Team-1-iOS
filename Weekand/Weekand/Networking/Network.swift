//
//  Network.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/02.
//

import Foundation
import Apollo
import RxSwift

enum ListSection: Int, CaseIterable {
  case launches
}

class NetWork {
    static let shared = NetWork()
    
    private(set) lazy var client: ApolloClient = {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = ["Access-Token": "\(Key.tempToken)"]
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        
        let sessionClient = URLSessionClient(sessionConfiguration: configuration, callbackQueue: .main)
        let provider = NetworkInterceptorProvider(client: sessionClient, shouldInvalidateClientOnDeinit: true, store: store)
        let url = URL(string: Key.graphqlUrl)!
        
        let requestChainTransport = RequestChainNetworkTransport(
                interceptorProvider: provider,
                endpointURL: url
        )
        
        return ApolloClient(
                networkTransport: requestChainTransport,
                store: store
        )
    }()
    
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Observable<Query.Data> {
        return self.client.rx
            .fetch(
                query: query,
                cachePolicy: cachePolicy,
                queue: queue
            ).asObservable()
    }
}
