//
//  HomeModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol HomeModuleFactory {

    func makeHomeHandler() -> HomeViewController
    
    func makeSelectCurrencyHandler(selection source: CurrencySource) -> SelectCurrencyViewController
}
