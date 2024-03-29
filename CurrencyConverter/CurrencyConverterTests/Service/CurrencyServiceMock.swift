//
//  CurrencyServiceMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation
@testable import CurrencyConverter

final class CurrencyServiceMock: CurrencyServiceProtocol {
    var target: CurrencyTarget.Type = CurrencyTarget.self
    
    
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }

    func list(handle: @escaping CurrencyService.ServiceCompletion<CurrenciesResponseModel>) {
        if shouldReturnError {
            let data = TestDataGenerator.getListCurrenciesDataWithError()
            handle(.success(try! data.decoded()))
            return
        }
        let data = TestDataGenerator.getListCurrenciesData()
        handle(.success(try! data.decoded()))
    }
    
    func convert(handle: @escaping CurrencyService.ServiceCompletion<ConversionResponseModel>) {
        if shouldReturnError {
              let data = TestDataGenerator.getQuotesDataWithError()
            handle(.success(try! data.decoded()))
            return
        }
        let data = TestDataGenerator.getQuotesData()
        handle(.success(try! data.decoded()))
    }
}

