//
//  RequestLoggingInterceptor.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import Apollo
import OSLog

class RequestLoggingInterceptor: ApolloInterceptor {

  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {

    let logger = Logger()
    logger.log(level: .debug, "Outgoing request: \(String(describing: request))")

    chain.proceedAsync(request: request,
                        response: response,
                        completion: completion)
  }
}
