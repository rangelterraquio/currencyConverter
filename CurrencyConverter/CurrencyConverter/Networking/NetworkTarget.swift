//
//  NetworkTarget.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

enum Method: String {
    case post = "POST"
    case get = "GET"
}

protocol Target {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: Method { get }
    
    var header: [String: String]? { get }
}

protocol NetworkTarget: Target { }

extension NetworkTarget {
    
    var baseURL: URL { NetworkConstants.URLs.baseURL }
    
    var header: [String : String]? { ["Content-Type": "application/json"] }
}
