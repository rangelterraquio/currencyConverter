//
//  NetworkConfiguration.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

enum NetworkEnvironment {
    case production
    // case development
    
    var baseURL: URL {
        switch self {
        case .production:
            guard let url =  URL(string: "http://api.currencylayer.com/") else {
                fatalError("Error to convert string url")
            }
            return url
        }
    }
    
    var allowsInsecureHTTP: Bool {
        switch self {
        case .production:
            return false
        }
    }
}

struct NetworkConfiguration {
    let environment: NetworkEnvironment
    let timeoutInterval: TimeInterval
    let enableLogging: Bool
    let apiKey: String
    
    init(environment: NetworkEnvironment = .production,
         timeoutInterval: TimeInterval = 10.0,
         enableLogging: Bool = true,
         apiKey: String? = nil) {
        
        self.environment = environment
        self.timeoutInterval = timeoutInterval
        self.enableLogging = enableLogging
        self.apiKey = apiKey ?? Self.getAPIKey()
    }
    
    static let `default` = NetworkConfiguration()
    
    private static func getAPIKey() -> String {
        // TODO: Should Try to get from environment variables or info.plist(more secure)
        // Hardcoded key (not recommended)
        return "fa48d928d7ceb255ad50098a18a50481"
    }
}

struct RequestConfiguration {
    // Properties useful for a real project
    let timeout: TimeInterval?
    let requiresAuthentication: Bool
    let additionalHeaders: [String: String]?
    
    init(timeout: TimeInterval? = nil,
         requiresAuthentication: Bool = true,
         additionalHeaders: [String: String]? = nil) {
        
        self.timeout = timeout
        self.requiresAuthentication = requiresAuthentication
        self.additionalHeaders = additionalHeaders
    }
    
    static let `default` = RequestConfiguration()
} 
