//
//  CurrencyTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation


enum CurrencyTarget {
    case convert(value: Float, from: Currency, to: Currency)
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
//    & from = USD
//        & to = GBP
//        & amount = 10
    
    var header: [String : String]? {
        var hearder: [String: String] = [:]
        hearder["access_key"] = NetworkConstants.api_key
        
        switch self {
        case .convert:
            return hearder
        case .list:
            hearder["access_key"] = NetworkConstants.api_key
            return hearder
        }
    }
}
