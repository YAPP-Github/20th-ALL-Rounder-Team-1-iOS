//
//  ‌ResponseLoggingInterceptor.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/29.
//

import Apollo
import OSLog

class ResponseLoggingInterceptor: ApolloInterceptor {

  enum ResponseLoggingError: Error {
    case notYetReceived
  }

  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {

    defer {
      // Even if we can't log, we still want to keep going.
      chain.proceedAsync(request: request,
                          response: response,
                          completion: completion)
    }

    guard let receivedResponse = response else {
      chain.handleErrorAsync(ResponseLoggingError.notYetReceived,
                              request: request,
                              response: response,
                              completion: completion)
      return
    }
        
    let logger = Logger()
    logger.log(level: .debug, "HTTP Response: \(receivedResponse.httpResponse)")

    if let stringData = String(bytes: receivedResponse.rawData, encoding: .utf8) {
        logger.log(level: .debug, "Data: \(stringData)")
    } else {
        logger.log(level: .error, "Could not convert data to string!")
    }
  }
}
