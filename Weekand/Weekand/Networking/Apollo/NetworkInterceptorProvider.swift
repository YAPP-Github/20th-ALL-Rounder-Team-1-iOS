//
//  NetworkInterceptorProvider.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/08.
//

import Foundation
import Apollo

class NetworkInterceptorProvider: InterceptorProvider {
    
    private let store: ApolloStore
      private let client: URLSessionClient
      
      init(store: ApolloStore,
           client: URLSessionClient) {
        self.store = store
        self.client = client
      }
      
      func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
          MaxRetryInterceptor(),
          CacheReadInterceptor(store: self.store),
          TokenAddingInterceptor(),
          RequestLoggingInterceptor(),
          NetworkFetchInterceptor(client: self.client),
          ResponseLoggingInterceptor(),
          ResponseCodeInterceptor(),
          JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
          RefreshTokenInterceptor(),
          AutomaticPersistedQueryInterceptor(),
          CacheWriteInterceptor(store: self.store)
        ]
      }
}
