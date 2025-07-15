//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    // MARK: - Properties
    var currencyConverter: CurrencyConverter!
    var mockQuotes: [String: Float]!
    var usdCurrency: Currency!
    var eurCurrency: Currency!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        currencyConverter = CurrencyConverter()
        mockQuotes = [
            "USDUSD": 1.0,
            "USDEUR": 0.85,
            "USDGBP": 0.75,
            "USDBRL": 5.5
        ]
        usdCurrency = Currency(code: "USD", name: "US Dollar")
        eurCurrency = Currency(code: "EUR", name: "Euro")
    }
    
    override func tearDown() {
        currencyConverter = nil
        mockQuotes = nil
        usdCurrency = nil
        eurCurrency = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSuccessfulConversion() {
        // Given
        let value: Float = 100.0
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.originalValue, value)
        XCTAssertEqual(result.convertedValue, 85.0, accuracy: 0.01)
        XCTAssertEqual(result.fromCurrency.currencyCode, "USD")
        XCTAssertEqual(result.toCurrency.currencyCode, "EUR")
    }
    
    func testSameCurrencyConversion() {
        // Given
        let value: Float = 100.0
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: usdCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.originalValue, value)
        XCTAssertEqual(result.convertedValue, value)
    }
    
    func testConversionWithInvalidFromCurrency() {
        // Given
        let value: Float = 100.0
        let invalidCurrency = Currency(code: nil, name: "Invalid")
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: invalidCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertFalse(result.success)
        XCTAssertNotNil(result.errorMessage)
        XCTAssertEqual(result.errorMessage, HomeConstants.ErrorMessages.invalidCurrencies)
    }
    
    func testConversionWithInvalidToCurrency() {
        // Given
        let value: Float = 100.0
        let invalidCurrency = Currency(code: nil, name: "Invalid")
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: invalidCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertFalse(result.success)
        XCTAssertNotNil(result.errorMessage)
        XCTAssertEqual(result.errorMessage, HomeConstants.ErrorMessages.invalidCurrencies)
    }
    
    func testConversionWithMissingFromQuote() {
        // Given
        let value: Float = 100.0
        let unknownCurrency = Currency(code: "XYZ", name: "Unknown")
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: unknownCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertFalse(result.success)
        XCTAssertNotNil(result.errorMessage)
        XCTAssertTrue(result.errorMessage!.contains("XYZ"))
    }
    
    func testConversionWithMissingToQuote() {
        // Given
        let value: Float = 100.0
        let unknownCurrency = Currency(code: "XYZ", name: "Unknown")
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: unknownCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertFalse(result.success)
        XCTAssertNotNil(result.errorMessage)
        XCTAssertTrue(result.errorMessage!.contains("XYZ"))
    }
    
    func testDecimalRounding() {
        // Given
        let value: Float = 100.0
        let quotes = ["USDUSD": 1.0, "USDEUR": 0.857142857] // Should round to 2 decimal places
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: eurCurrency,
            quotes: quotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.convertedValue, 85.71, accuracy: 0.01)
    }
    
    func testFormatConversionResult() {
        // Given
        let successResult = CurrencyConversionResult.success(
            originalValue: 100.0,
            convertedValue: 85.0,
            from: usdCurrency,
            to: eurCurrency
        )
        
        // When
        let formatted = currencyConverter.formatConversionResult(successResult)
        
        // Then
        XCTAssertEqual(formatted, "100.00 USD = 85.00 EUR")
    }
    
    func testFormatConversionResultWithError() {
        // Given
        let errorResult = CurrencyConversionResult.failure(
            originalValue: 100.0,
            from: usdCurrency,
            to: eurCurrency,
            error: "Test error"
        )
        
        // When
        let formatted = currencyConverter.formatConversionResult(errorResult)
        
        // Then
        XCTAssertEqual(formatted, "Test error")
    }
    
    func testConversionWithZeroValue() {
        // Given
        let value: Float = 0.0
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.convertedValue, 0.0)
    }
    
    func testConversionWithLargeValue() {
        // Given
        let value: Float = 1000000.0
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: usdCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.convertedValue, 850000.0, accuracy: 0.01)
    }
    
    func testConversionWithComplexRates() {
        // Given
        let value: Float = 50.0
        let brlCurrency = Currency(code: "BRL", name: "Brazilian Real")
        
        // When
        let result = currencyConverter.convert(
            value: value,
            from: brlCurrency,
            to: eurCurrency,
            quotes: mockQuotes
        )
        
        // Then
        XCTAssertTrue(result.success)
        // 50 BRL / 5.5 = 9.09 USD, then 9.09 * 0.85 = 7.73 EUR
        XCTAssertEqual(result.convertedValue, 7.73, accuracy: 0.01)
    }
} 
