//
//  UserDefaults+Extension.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation

extension UserDefaults {
    
    static var lastCurrenciesListUpdate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastCurrenciesListUpdate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey:"lastCurrenciesListUpdate")
        }
    }
    
    static var lastQuotesUpdate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastQuotesUpdate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey:"lastQuotesUpdate")
        }
    }
}
