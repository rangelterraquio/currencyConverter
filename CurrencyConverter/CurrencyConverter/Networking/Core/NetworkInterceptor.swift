//
//  NetworkInterceptor.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

protocol NetworkInterceptor {
    func intercept(request: URLRequest, configuration: NetworkConfiguration) -> URLRequest
    func intercept(response: HTTPURLResponse?, data: Data?, error: Error?, for request: URLRequest) -> InterceptionResult
}

enum InterceptionResult {
    case proceed(data: Data?, error: Error?)
    case retry(after: TimeInterval)
    case fail(error: Error)
}

/// Good examples of interceptors would be RetryInterceptor, AuthenticatorInterceptor
final class LoggingInterceptor: NetworkInterceptor {
    
    private let logger: NetworkLoggerProtocol
    private let isEnabled: Bool
    
    init(logger: NetworkLoggerProtocol = NetworkLogger(), isEnabled: Bool = true) {
        self.logger = logger
        self.isEnabled = isEnabled
    }
    
    func intercept(request: URLRequest, configuration: NetworkConfiguration) -> URLRequest {
        if isEnabled && configuration.enableLogging {
            logger.logRequest(request)
        }
        return request
    }
    
    func intercept(response: HTTPURLResponse?, data: Data?, error: Error?, for request: URLRequest) -> InterceptionResult {
        if isEnabled {
            logger.logResponse(response, data: data, error: error, for: request)
        }
        return .proceed(data: data, error: error)
    }
}

protocol NetworkLoggerProtocol {
    func logRequest(_ request: URLRequest)
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, for request: URLRequest)
}

final class NetworkLogger: NetworkLoggerProtocol {

    func logRequest(_ request: URLRequest) {
        let logMessage = "📱 [Network Request] -> URL: \(String(describing: request.url?.absoluteString)) \n"
        print(logMessage)
    }
    
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, for request: URLRequest) {
        let logMessage = "📲 [Network Response] -> \(String(describing: response))  \n"
        print(logMessage)
    }
} 
