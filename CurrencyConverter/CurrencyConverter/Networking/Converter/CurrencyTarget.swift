//
//  CurrencyTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

enum CurrencyTarget {
    case list
    case convert(from: String, to: String, amount: Float)
}

extension CurrencyTarget: NetworkTarget {
    
    var path: String {
        switch self {
        case .convert:
            return "live"
        case .list:
            return "list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .convert, .list:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type" : "application/json"
        ]
    }
    
    var queryParameters: [String: String]? {
        var parameters: [String: String] = ["access_key": NetworkConfiguration.default.apiKey]
        
        switch self {
        case .list:
            break
            
        case .convert(let from, let to, let amount):
            parameters["from"] = from
            parameters["to"] = to
            parameters["amount"] = String(amount)
        }
        
        return parameters
    }
}

// MARK: - Convenience Factory Methods
extension CurrencyTarget {
    static func convert(amount: Float, from: String, to: String) -> CurrencyTarget {
        return .convert(from: from, to: to, amount: amount)
    }
    
    static func list() -> CurrencyTarget {
        return .list
    }
}
