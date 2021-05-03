//
//  SelectCurrencyModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol SelectCurrencyModuleFactory {
    /// Method to create SelectCurrencyModuleFactory
    /// - Returns: UIViewController
    func makeSelectCurrencyHandler() -> SelectCurrencyViewController
}
