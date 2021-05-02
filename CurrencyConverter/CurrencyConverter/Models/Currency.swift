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
//struct CurrencyType {
//
//}


//typealias Current = <#type expression#>
struct CurrenciesResponseModel: Codable {
    var currencies: [String:String]
    var success: Bool
    
//    private enum CodingKeys: String, CodingKey  {
//        case currencies = "currencies"
//        case success = "success"
//    }
}
