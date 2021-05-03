//
//  SelectCurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

class SelectCurrencyViewModel: NSObject {
    
    private let currencyService: CurrencyService
    
    public var bindListAvaiableCurrencies: (([Currency]) -> Void)?
    
    init(service: CurrencyService = CurrencyService()) {
        currencyService = service
    }
    
    
    func list() {
        currencyService.list { [weak self] (response) in
            switch response {
                case .success(let model):
                    if let model = model, let currencies = model.currencies {
                        self?.bindListAvaiableCurrencies?(currencies)
                    }
                case.error( _ ):
                    break
            }
        }
    }
    
    
}
