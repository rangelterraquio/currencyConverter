//
//  InputValidator.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
    
    static let valid = ValidationResult(isValid: true, errorMessage: nil)
    
    static func invalid(message: String) -> ValidationResult {
        return ValidationResult(isValid: false, errorMessage: message)
    }
}

protocol InputValidatorProtocol {
    func validateValue(_ value: String?) -> ValidationResult
    func validateCurrencies(from: Currency?, to: Currency?) -> ValidationResult
    func validateConversionInputs(value: String?, from: Currency?, to: Currency?) -> ValidationResult
}

final class InputValidator: InputValidatorProtocol {
    
    private let minimumValue: Float
    private let maximumValue: Float

    init(minimumValue: Float = HomeConstants.Validation.minimumValue,
         maximumValue: Float = HomeConstants.Validation.maximumValue) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
    
    func validateValue(_ value: String?) -> ValidationResult {
        // Check if value is provided
        guard let value = value, !value.isEmpty else {
            return ValidationResult.invalid(message: HomeConstants.ErrorMessages.invalidInput)
        }
        
        // Check if value is a valid number
        guard let floatValue = Float(value) else {
            return ValidationResult.invalid(message: HomeConstants.ErrorMessages.invalidInput)
        }
        
        // Check minimum value
        guard floatValue >= minimumValue else {
            return ValidationResult.invalid(message: "Value must be at least \(minimumValue)")
        }
        
        // Check maximum value
        guard floatValue <= maximumValue else {
            return ValidationResult.invalid(message: "Value must be less than \(maximumValue)")
        }
        
        // Check for reasonable decimal places
        if hasExcessiveDecimalPlaces(value) {
            return ValidationResult.invalid(message: "Too many decimal places")
        }
        
        return ValidationResult.valid
    }
    
    func validateCurrencies(from: Currency?, to: Currency?) -> ValidationResult {
        // Check if both currencies are provided
        guard let fromCurrency = from, let toCurrency = to else {
            return ValidationResult.invalid(message: HomeConstants.ErrorMessages.invalidCurrencies)
        }
        
        // Check if currencies have valid codes
        guard let fromCode = fromCurrency.currencyCode, !fromCode.isEmpty,
              let toCode = toCurrency.currencyCode, !toCode.isEmpty else {
            return ValidationResult.invalid(message: HomeConstants.ErrorMessages.invalidCurrencies)
        }
        
        // Validate currency code format (should be 3 characters)
        if !isValidCurrencyCode(fromCode) || !isValidCurrencyCode(toCode) {
            return ValidationResult.invalid(message: HomeConstants.ErrorMessages.invalidCurrencies)
        }
        
        return ValidationResult.valid
    }
    
    func validateConversionInputs(value: String?, from: Currency?, to: Currency?) -> ValidationResult {
        // Validate value
        let valueValidation = validateValue(value)
        if !valueValidation.isValid {
            return valueValidation
        }
        
        // Validate currencies
        let currencyValidation = validateCurrencies(from: from, to: to)
        if !currencyValidation.isValid {
            return currencyValidation
        }
        
        return ValidationResult.valid
    }
    
    private func hasExcessiveDecimalPlaces(_ value: String) -> Bool {
        if let dotIndex = value.firstIndex(of: ".") {
            let decimalPart = value.suffix(from: value.index(after: dotIndex))
            return decimalPart.count > HomeConstants.Validation.decimalPlaces
        }
        return false
    }
    
    private func isValidCurrencyCode(_ code: String) -> Bool {
        // Currency codes should be 3 characters and contain only letters
        return code.count == 3 && code.allSatisfy { $0.isLetter && $0.isUppercase }
    }
} 
