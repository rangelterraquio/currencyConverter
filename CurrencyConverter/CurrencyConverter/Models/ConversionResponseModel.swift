//
//  ConversionResponseModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
//{
//    "success": true,
//    "terms": "https://currencylayer.com/terms",
//    "privacy": "https://currencylayer.com/privacy",
//    "timestamp": 1430068515,
//    "source": "USD",
//    "quotes": {
//        "USDAUD": 1.278384,
//        "USDCHF": 0.953975,
//        "USDEUR": 0.919677,
//        "USDGBP": 0.658443,
//        "USDPLN": 3.713873
//    }
//}

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
    var quotesModel: [Quote]? = []
    var quotes: [String:Float]?
    let timestamp: TimeInterval
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        source = try? values.decode(String.self, forKey: .source)
        quotes = try? values.decode([String:Float].self, forKey: .quotes)
        timestamp = try values.decode(TimeInterval.self, forKey: .timestamp)
        
        defer { setQuoteModel() }
    }
    private mutating func setQuoteModel() {
        self.quotesModel = quotes?.map({ Quote(currency: $0.key, value: $0.value)}) ?? []
    }
    
   private enum CodingKeys: String, CodingKey {
            case success
            case source
            case quotes
            case timestamp
  }
}
