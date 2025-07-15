//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias Completion<T> = (Result<T, Error>) -> Void
    
    func request<T: Decodable>(_ target: NetworkTarget,
                              responseType: T.Type,
                              configuration: RequestConfiguration?,
                              completion: @escaping Completion<T>)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let configuration: NetworkConfiguration
    
    init(networkClient: NetworkClientProtocol? = nil,
         configuration: NetworkConfiguration = .default) {
        
        if let networkClient = networkClient {
            self.networkClient = networkClient
        } else {
            self.networkClient = NetworkClient(configuration: configuration)
        }
        
        self.configuration = configuration
    }
    
    func request<T: Decodable>(_ target: NetworkTarget,
                              responseType: T.Type,
                              configuration: RequestConfiguration? = nil,
                              completion: @escaping Completion<T>) {
        
        networkClient.request(target, responseType: responseType, configuration: configuration) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// MARK: - Network Service Factory
final class NetworkServiceFactory {
    
    static func create(configuration: NetworkConfiguration = .default) -> NetworkServiceProtocol {
        return NetworkService(configuration: configuration)
    }

    // static func createMock(mockSession: URLSessionProtocol) -> NetworkServiceProtocol
}
