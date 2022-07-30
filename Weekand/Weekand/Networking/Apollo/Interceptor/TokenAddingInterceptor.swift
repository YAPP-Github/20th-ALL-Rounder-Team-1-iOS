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
    
    /// Helper function to add the token then move on to the next step
    private func addTokensForLogout<Operation: GraphQLOperation>(
        accessToken: String,
        refreshToken: String,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            request.addHeader(name: "Access-Token", value: accessToken)
            request.addHeader(name: "Refresh-Token", value: refreshToken)
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            if let token = TokenManager.shared.readAccessToken() {
                if TokenManager.shared.isExpired {
                    if let refreshToken = TokenManager.shared.readRefreshToken() {
                        self.addRefreshTokenAndProceed(refreshToken,
                                                       to: request,
                                                       chain: chain,
                                                       response: response,
                                                       completion: completion)
                    }
                } else {
                    if request.operation.operationName == "Logout" {
                        if let refreshToken = TokenManager.shared.readRefreshToken() {
                            self.addTokensForLogout(accessToken: token,
                                                    refreshToken: refreshToken,
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
                    
                }
            } else {
                chain.proceedAsync(request: request,
                                   response: response,
                                   completion: completion)
                
            }
            
        }
}
