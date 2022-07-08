//
//  TokenAddingInterceptor.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/08.
//

import Foundation
import Apollo

class TokenAddingInterceptor: ApolloInterceptor {
    
    enum UserError: Error {
        case noUserLoggedIn
    }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            let token = Key.tempToken
            request.addHeader(name: "Access-Token", value: token)
            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}