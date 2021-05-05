//
//  TestDataGenerator.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation


final class TestDataGenerator {
    
    static func getQuotesData() -> Data {
        let json = """
            {
                "success": true,
                "timestamp": 1430401802,
                "source": "USD",
                "quotes": {
                    "USDAED": 3.672982,
                    "USDAFN": 57.8936,
                    "USDALL": 126.1652,
                    "USDAMD": 475.306,
                    "USDANG": 1.78952,
                    "USDAOA": 109.216875,
                    "USDARS": 8.901966,
                    "USDAUD": 1.269072,
                    "USDAWG": 1.792375,
                    "USDAZN": 1.04945,
                    "USDBAM": 1.757305
                }
            }
            """
        return json.data(using: .utf8)!
    }
    
    static func getQuotesDataWithError() -> Data {
        let json = """
            {
                "success": false,
                "error": {
                    "code": 201,
                    "info": "You have supplied an invalid Source Currency. [Example: source=EUR]"
              }
            }
            """
        return json.data(using: .utf8)!
    }
    
    static func getListCurrenciesDataWithError() -> Data {
        let json = """
            {
                "success": false,
                "error": {
                    "code": 104,
                    "info": "Your monthly usage limit has been reached. Please upgrade your subscription plan."
              }
            }
            """
        return json.data(using: .utf8)!
    }
    
    static func getListCurrenciesData() -> Data {
        let json = """
            {
                "success": true,
                "currencies": {
                    "AED": "United Arab Emirates Dirham",
                    "AFN": "Afghan Afghani",
                    "ALL": "Albanian Lek",
                    "AMD": "Armenian Dram",
                    "ANG": "Netherlands Antillean Guilder",
                }
            }
            """
        return json.data(using: .utf8)!
    }
}

