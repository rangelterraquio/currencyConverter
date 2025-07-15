//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol CurrencyServiceProtocol {
    typealias Completion<T> = (Result<T, Error>) -> Void
    
    func fetchList(completion: @escaping Completion<CurrenciesResponseModel>)
    func convert(amount: Float, from: String, to: String, completion: @escaping Completion<ConversionResponseModel>)
}

final class CurrencyService: CurrencyServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let configuration: NetworkConfiguration

    init(configuration: NetworkConfiguration = .default) {
        self.networkService = NetworkServiceFactory.create(configuration: configuration)
        self.configuration = configuration
    }
    
    func fetchList(completion: @escaping Completion<CurrenciesResponseModel>) {
        let target = CurrencyTarget.list
        networkService.request(target, responseType: CurrenciesResponseModel.self, configuration: nil, completion: completion)
    }
    
    func convert(amount: Float, from: String, to: String, completion: @escaping Completion<ConversionResponseModel>) {
        let target = CurrencyTarget.convert(from: from, to: to, amount: amount)
        networkService.request(target, responseType: ConversionResponseModel.self, configuration: nil, completion: completion)
    }
}

// MARK: - CurrencyService Factory
extension CurrencyService {
    
    static func create(configuration: NetworkConfiguration = .default) -> CurrencyService {
        return CurrencyService(configuration: configuration)
    }
}
