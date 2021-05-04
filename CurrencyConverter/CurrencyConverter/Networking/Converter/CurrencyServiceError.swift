//
//  CurrencyServiceError.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation

enum CurrencyServiceError: Error {
    
    case apiError
    case invalidAmount
    case invalidCurrencies
    case connectioError
    
    init(code: Int) {
        switch code {
        case 401,402:
            self = .invalidCurrencies
        case 403:
            self = .invalidAmount
        default:
            self = .apiError
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .apiError:
            return "Something goes wrong on server. Try again!"
        case .invalidAmount:
            return "Invalid value. Try again!"
        case .invalidCurrencies:
            return "One of currencis is invalid. Try again!"
        case .connectioError:
            return "The device is not connected, reconnect and try again!"
        }
    }
}
