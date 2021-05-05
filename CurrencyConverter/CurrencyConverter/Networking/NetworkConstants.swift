//
//  NetworkConstants.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

struct NetworkConstants {
 
    struct URLs {
        static var baseURL: URL {
            guard let url =  URL(string: "http://api.currencylayer.com/") else {
                fatalError("Error to convert string url")
            }
            return url
        }
    }
    
    static let api_key = "fa48d928d7ceb255ad50098a18a50481"
}
