//
//  ModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

final class ModuleFactory: HomeModuleFactory {
   
    func makeSelectCurrencyHandler(selection source: CurrencySource) -> SelectCurrencyViewController {
        let vc = SelectCurrencyViewController(viewModel: SelectCurrencyViewModel(currencySource: source))
        return vc
    }
    
    func makeHomeHandler() -> HomeViewController {
        let vc = HomeViewController()
        return vc
    }
}
