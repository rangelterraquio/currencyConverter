//
//  SelectCurrencyDelegate.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol SelectCurrencyDelegate: AnyObject {
    func didSelect(currency: Currency, source: CurrencySource)
}
