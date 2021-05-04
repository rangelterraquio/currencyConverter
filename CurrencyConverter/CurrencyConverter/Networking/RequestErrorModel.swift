//
//  RequestErrorModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation

struct RequestErrorModel {
    let error: Error?
    let response: HTTPURLResponse?
    
    init(error: Error?, response: HTTPURLResponse?) {
        self.error = error
        self.response = response
    }
}
