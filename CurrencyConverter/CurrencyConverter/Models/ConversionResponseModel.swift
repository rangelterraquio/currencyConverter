//
//  ConversionResponseModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

struct Info: Decodable {
    let quote: Float
}
struct QueryInfo: Decodable {
    let from: String
    let to: String
    let amount: Float
}

struct Quote: Decodable {
    let currency: String
    let value: Float
    
    init(currency: String, value: Float) {
        self.currency = currency
        self.value = value
    }
}

struct ConversionResponseModel: Decodable {
    let success: Bool
    let source: String?
    var quotes: [String:Float]?
    let timestamp: TimeInterval?
    let error: CurrencyServiceError?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        source = try? values.decode(String.self, forKey: .source)
        quotes = try? values.decode([String:Float].self, forKey: .quotes)
        timestamp = try? values.decode(TimeInterval.self, forKey: .timestamp)
        error = try? values.decode(CurrencyServiceError.self, forKey: .error)
    }
    
    private enum CodingKeys: String, CodingKey {
        case success
        case source
        case quotes
        case timestamp
        case error
    }
}
