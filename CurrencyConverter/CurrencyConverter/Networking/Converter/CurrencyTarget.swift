//
//  CurrencyTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

enum CurrencyTarget {
    case convert
    case list
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
    
    var method: Method {
        switch self {
        case .convert:
            return .post
        case .list:
            return .get
        }
    }
    
    var header: [String : String]? {
        var hearder: [String: String] = [:]
        hearder["access_key"] = NetworkConstants.api_key
        switch self {
        case .convert:
            return hearder
        case .list:
            return hearder
        }
    }
}
