//
//  CurrencyConversionError.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25.
//

import Foundation

protocol AppError: Error {
    var message: String { get }
    // Other useful error properties
}

enum AppErrorBase: AppError, Error {
    case unknown
    case custom(message: String)
    
    var message: String {
        if case .custom(let message) = self {
            return message
        }
        
        return "Unknown error"
    }
}

enum CurrencyConversionError: AppError {
    case invalidCurrency
    case networkFailure
    case custom(message: String)
    
    var title: String {
        switch self {
        case .invalidCurrency:
            return "Invalid Currency"
        case .networkFailure:
            return "Network Error"
        case .custom:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .invalidCurrency:
            return "Please enter a valid currency"
        case .networkFailure:
            return "Unable to connect to server"
        case .custom(message: let message):
            return message
        }
    }
}
