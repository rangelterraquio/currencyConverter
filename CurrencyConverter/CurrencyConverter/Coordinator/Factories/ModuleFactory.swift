//
//  ModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

/// Factory for modules
final class ModuleFactory: HomeModuleFactory {
   
    
    func makeSelectCurrencyHandler(selection source: SelectCurrencyViewController.CurrencySource) -> SelectCurrencyViewController {
        let vc = SelectCurrencyViewController(currencySource: source)
        return vc
    }
    
    func makeHomeHandler() -> HomeViewController {
        let vc = HomeViewController()
        return vc
    }
}
