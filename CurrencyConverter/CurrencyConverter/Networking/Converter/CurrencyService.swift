//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol CurrencyServiceProtocol: NetworkService {
 
    func convert(value: Float, from: CurrenciesResponseModel, to: CurrenciesResponseModel, handle: @escaping ServiceCompletion<Void>)
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>)
}

class CurrencyService: CurrencyServiceProtocol {
    typealias Target = CurrencyTarget
    
    func convert(value: Float, from: CurrenciesResponseModel, to: CurrenciesResponseModel, handle: @escaping ServiceCompletion<Void>) {
        request(target: .convert(value: value, from: from, to: to), then: handle)
    }
    
    func list(handle: @escaping ServiceCompletion<CurrenciesResponseModel>) {
        request(target: .list, then: handle)
    }
}
