//
//  SelectCurrencyModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol SelectCurrencyModuleFactory {

    func makeSelectCurrencyHandler() -> SelectCurrencyViewController
}
