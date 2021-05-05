//
//  SelectCurrencyDelegate.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol SelectCurrencyDelegate: class {
    func didSelect(currency: Currency, source: SelectCurrencyViewController.CurrencySource)
}
