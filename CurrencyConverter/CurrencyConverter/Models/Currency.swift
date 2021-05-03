//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

//{
//    "success": true,
//    "terms": "https://currencylayer.com/terms",
//    "privacy": "https://currencylayer.com/privacy",
//    "currencies": {
//        "AED": "United Arab Emirates Dirham",
//        "AFN": "Afghan Afghani",
//        "ALL": "Albanian Lek",
//        "AMD": "Armenian Dram",
//        "ANG": "Netherlands Antillean Guilder",
//        [...]
//    }
//}

//
struct Currency: Decodable {
    
    let currencyCode: String
    let currencyName: String
    
    init(code: String, name: String) {
        self.currencyCode = code
        self.currencyName = name
    }
}

extension Currency: Equatable {
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.currencyCode == rhs.currencyCode && lhs.currencyName == rhs.currencyName
    }
}



struct CurrenciesResponseModel: Codable {
    private var _currencies: [String : String]?
    var success: Bool
    var currencies: [Currency]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        _currencies = try? values.decode([String:String].self, forKey: ._currencies)
        
        defer { setCurrenciesModel() }
    }
    private mutating func setCurrenciesModel() {
        self.currencies = _currencies?.map({ Currency(code: $0.key, name: $0.value)}) ?? []
    }
   
    private enum CodingKeys: String, CodingKey  {
        case _currencies = "currencies"
        case success = "success"
    }
}
