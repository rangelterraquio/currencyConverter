//
//  NetworkError.swift
//  CurrencyConverter
//
//  Created by Rangel Dias on 15/07/25.
//

import Foundation

enum NetworkError: AppError, Error {
    case noInternetConnection
    case invalidURL
    case invalidResponse
    case decodingFailed
    case timeout
    case unknown
    
    var message: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection"
        case .invalidURL:
            return "Invalid URL"
        case .decodingFailed:
            return "Decoding failed"
        case .unknown:
            return "Unknown error"
        case .timeout:
            return "Timeout"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
