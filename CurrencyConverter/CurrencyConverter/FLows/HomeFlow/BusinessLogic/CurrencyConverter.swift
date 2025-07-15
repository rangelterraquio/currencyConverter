//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

protocol CurrencyConverterProtocol {
    func convert(value: Float, from: Currency, to: Currency, quotes: [String: Float]) -> CurrencyConversionResult
    func formatConversionResult(_ result: CurrencyConversionResult) -> String
}

struct CurrencyConversionResult {
    let originalValue: Float
    let convertedValue: Float
    let fromCurrency: Currency
    let toCurrency: Currency
    let success: Bool
    let errorMessage: String?
    
    static func success(originalValue: Float,
                        convertedValue: Float,
                        from: Currency,
                        to: Currency) -> CurrencyConversionResult {
        return CurrencyConversionResult(
            originalValue: originalValue,
            convertedValue: convertedValue,
            fromCurrency: from,
            toCurrency: to,
            success: true,
            errorMessage: nil
        )
    }
    
    static func failure(originalValue: Float,
                        from: Currency,
                        to: Currency,
                        error: String) -> CurrencyConversionResult {
        return CurrencyConversionResult(
            originalValue: originalValue,
            convertedValue: 0,
            fromCurrency: from,
            toCurrency: to,
            success: false,
            errorMessage: error
        )
    }
}

final class CurrencyConverter: CurrencyConverterProtocol {
    
    private let decimalPlaces: Int
    
    // MARK: - Initialization
    init(decimalPlaces: Int = HomeConstants.Validation.decimalPlaces) {
        self.decimalPlaces = decimalPlaces
    }
    
    func convert(value: Float,
                 from: Currency,
                 to: Currency,
                 quotes: [String: Float]) -> CurrencyConversionResult {
        // Validate input parameters
        guard let fromCode = from.currencyCode, let toCode = to.currencyCode else {
            return CurrencyConversionResult.failure(
                originalValue: value,
                from: from,
                to: to,
                error: HomeConstants.ErrorMessages.invalidCurrencies
            )
        }
        
        // Handle same currency conversion
        if fromCode == toCode {
            return CurrencyConversionResult.success(
                originalValue: value,
                convertedValue: value,
                from: from,
                to: to
            )
        }
        
        // Perform conversion calculation
        let conversionResult = performConversion(
            value: value,
            fromCode: fromCode,
            toCode: toCode,
            quotes: quotes
        )
        
        return conversionResult
    }
    
    func formatConversionResult(_ result: CurrencyConversionResult) -> String {
        guard result.success else {
            return result.errorMessage ?? HomeConstants.ErrorMessages.unknownError
        }
        
        let fromCode = result.fromCurrency.currencyCode ?? "?"
        let toCode = result.toCurrency.currencyCode ?? "?"
        
        return String(format: "%.2f %@ = %.2f %@", 
                     result.originalValue, 
                     fromCode, 
                     result.convertedValue, 
                     toCode)
    }
    
    private func performConversion(value: Float,
                                   fromCode: String,
                                   toCode: String,
                                   quotes: [String: Float]) -> CurrencyConversionResult {
        // Get the USD rate for the 'from' currency
        let fromUSDKey = "USD\(fromCode)"
        let toUSDKey = "USD\(toCode)"
        let usdQuoteKey = HomeConstants.DefaultCurrencies.usdQuoteKey
        var fromUSDRate = Float(1.0)
        var toUSDRate = Float(1.0)
        let isFromKeyNotUSD = fromUSDKey != usdQuoteKey
        let isToKeyNotUSD = toUSDKey != usdQuoteKey
        
        
        if isFromKeyNotUSD {
            guard let quote = quotes[fromUSDKey] else {
                return CurrencyConversionResult.failure(
                    originalValue: value,
                    from: Currency(code: fromCode, name: ""),
                    to: Currency(code: toCode, name: ""),
                    error: "Exchange rate not found for \(fromCode)"
                )
            }
            fromUSDRate = quote
        }
        
        if isToKeyNotUSD {
            guard let quote = quotes[toUSDKey] else {
                return CurrencyConversionResult.failure(
                    originalValue: value,
                    from: Currency(code: fromCode, name: ""),
                    to: Currency(code: toCode, name: ""),
                    error: "Exchange rate not found for \(toCode)"
                )
            }
            toUSDRate = quote
        }
        
        // Convert to USD first, then to target currency
        let amountInUSD = value / fromUSDRate
        let convertedAmount = amountInUSD * toUSDRate
        
        // Round to specified decimal places
        let roundedAmount = roundToDecimalPlaces(convertedAmount, places: decimalPlaces)
        
        return CurrencyConversionResult.success(
            originalValue: value,
            convertedValue: roundedAmount,
            from: Currency(code: fromCode, name: ""),
            to: Currency(code: toCode, name: "")
        )
    }
    
    private func roundToDecimalPlaces(_ value: Float, places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (value * divisor).rounded() / divisor
    }
} 
