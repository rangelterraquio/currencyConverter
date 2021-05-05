//
//  CurrencyServiceError.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation

struct CurrencyServiceError: Decodable {
    
    static let unkown = CurrencyServiceError(code: -1, description: "Something goes Wrong. Try Again!")
    static let invalidCurrencies = CurrencyServiceError(code: -2, description: "Invalid currencies. Try Again!")
    static let notConnected = CurrencyServiceError(code: -3, description: "Your device is not connected, reconnect and try Again!")
    
    let code: Int
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case code
        case description = "info"
    }    
}
