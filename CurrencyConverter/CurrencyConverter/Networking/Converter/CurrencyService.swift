//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol CurrencyServiceProtocol: NetworkService {
 
    func convert(handle: @escaping ServiceCompletion<ConversionResponseModel>)
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>)
}

class CurrencyService: CurrencyServiceProtocol {
    typealias Target = CurrencyTarget
    
    func convert(handle: @escaping ServiceCompletion<ConversionResponseModel>) {
        
        request(target: .convert, then: handle)
    }
    
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>) {
        request(target: .list, then: handle)
    }
}
