//
//  CurrencyServiceMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation
@testable import CurrencyConverter

final class CurrencyServiceMock: CurrencyServiceProtocol {
    
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }

    func fetchList(completion: @escaping Completion<CurrenciesResponseModel>) {
        if shouldReturnError {
            let error = CurrencyConversionError.networkFailure
            completion(.failure(error))
            return
        }
        
        do {
            let data = TestDataGenerator.getListCurrenciesData()
            let result = try data.decoded() as CurrenciesResponseModel
            completion(.success(result))
        } catch {
            completion(.failure(CurrencyConversionError.networkFailure))
        }
    }
    
    func convert(amount: Float, from: String, to: String, completion: @escaping Completion<ConversionResponseModel>) {
        if shouldReturnError {
            let error = CurrencyConversionError.networkFailure
            completion(.failure(error))
            return
        }
        
        do {
            let data = TestDataGenerator.getQuotesData()
            let result = try data.decoded() as ConversionResponseModel
            completion(.success(result))
        } catch {
            completion(.failure(CurrencyConversionError.networkFailure))
        }
    }
}

