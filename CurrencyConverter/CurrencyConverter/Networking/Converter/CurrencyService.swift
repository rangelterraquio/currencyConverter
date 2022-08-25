//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol CurrencyServiceProtocol: NetworkService {
    var target: CurrencyTarget.Type { get }
    func convert(handle: @escaping ServiceCompletion<ConversionResponseModel>)
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>)
}

class CurrencyService: CurrencyServiceProtocol {
    var target: CurrencyTarget.Type = CurrencyTarget.self
    
    func convert(handle: @escaping ServiceCompletion<ConversionResponseModel>) {
        request(target: target.convert, then: handle)
    }
    
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>) {
        request(target: target.list, then: handle)
    }
}
