//
//  NetworkTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

// MARK: - HTTP Method
enum HTTPMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    // should put other httpMethods
}

// MARK: - NetworkTarget Protocol
protocol NetworkTarget {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    var queryParameters: [String: String]? { get }
    
    var body: Data? { get }
    
    var requestConfiguration: RequestConfiguration { get }
}

// MARK: - Default Implementations
extension NetworkTarget {
    
    var baseURL: URL { 
        return NetworkConfiguration.default.environment.baseURL
    }
    
    var headers: [String: String]? { 
        return ["Content-Type" : "application/json"]
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    var requestConfiguration: RequestConfiguration {
        return .default
    }
}
