//
//  HomeConstants.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

enum HomeConstants {
    
    // MARK: - Default Currencies
    enum DefaultCurrencies {
        static let from = CurrencyInfo(code: "BRL", name: "Brazilian Real")
        static let to = CurrencyInfo(code: "USD", name: "United States Dollar")
        static let usdQuoteKey = "USDUSD"
    }
    
    // MARK: - Currency Info
    struct CurrencyInfo {
        let code: String
        let name: String
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let invalidInput = "Please enter a valid number"
        static let invalidCurrencies = "Please select valid currencies"
        static let networkError = "Network error. Please check your connection."
        static let unknownError = "Something went wrong. Please try again."
    }
    
    // MARK: - Validation
    enum Validation {
        static let minimumValue: Float = 0.01
        static let maximumValue: Float = 999999.99
        static let decimalPlaces = 2
    }
    
    // MARK: - Input
    enum Input {
        static let allowedCharacters = "0123456789."
        static let placeholder = "Enter amount"
    }
} 
