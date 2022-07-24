//
//  RefreshTokenInterceptor.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Apollo
import RxSwift

class RefreshTokenInterceptor: ApolloInterceptor {
    
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
        if let response = response {
            
            if let error = response.parsedResponse?.errors?.first,
               error.description == NetworkError.expiredToken.errorDescription {
                ToeknManager.shared.accessToken?.isExpired = true
                ToeknManager.shared.reissue { result in
                    switch result {
                    case .success:
                        chain.retry(request: request, completion: completion)
                    case .failure(let error):
                        chain.handleErrorAsync(error, request: request, response: response, completion: completion)
                    }
                }
            } else {
                chain.proceedAsync(request: request,
                                   response: response,
                                   completion: completion)
            }
        }
    }
}
