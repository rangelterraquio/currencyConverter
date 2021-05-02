//
//  CurrencyTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation


enum CurrencyTarget {
    case convert(value: Float, from: CurrenciesResponseModel, to: CurrenciesResponseModel)
    case list
}

extension CurrencyTarget: NetworkTarget {
    var path: String {
        switch self {
        case .convert(let value,let from, let to):
            return ""
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
        switch self {
        case .convert:
            return [:]
        case .list:
            var hearder: [String: String] = [:]
            hearder["access_key"] = NetworkConstants.api_key
            return hearder
        }
    }
}
