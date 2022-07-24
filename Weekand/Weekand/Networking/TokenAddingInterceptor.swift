//
//  TokenService.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/23.
//
import Apollo

class TokenAddingInterceptor: ApolloInterceptor {
    
    /// Helper function to add the token then move on to the next step
    private func addTokenAndProceed<Operation: GraphQLOperation>(
        _ token: String,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            request.addHeader(name: "Access-Token", value: token)
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
    
    private func addRefreshTokenAndProceed<Operation: GraphQLOperation>(
        _ token: String,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            request.addHeader(name: "Refresh-Token", value: token)
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            if let token = ToeknManager.shared.readAccessToken() {
                if ToeknManager.shared.isExpired {
                    if let refreshToken = ToeknManager.shared.readRefreshToken() {
                        self.addRefreshTokenAndProceed(refreshToken,
                                                       to: request,
                                                       chain: chain,
                                                       response: response,
                                                       completion: completion)
                    }
                } else {
                    self.addTokenAndProceed(token,
                                            to: request,
                                            chain: chain,
                                            response: response,
                                            completion: completion)
                }
            } else {
                chain.proceedAsync(request: request,
                                   response: response,
                                   completion: completion)
                
            }
            
        }
}
