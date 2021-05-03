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
    public var bindLoadingState: (() -> Void)?
    
    let dataManager = DataManager.shared
    
    private var currencies: [Currency] = []
    
    private var selectedFilter: SelectCurrencyFilter = .none
    private var currenciesFilteredByCode: [Currency] {
        currencies.sorted { $0.currencyCode ?? "" < $1.currencyCode ?? "" }
    }
    
    private var currenciesFIlteredByName: [Currency] {
        currencies.sorted { $0.currencyName ?? "" < $1.currencyName ?? "" }
    }
    
    init(service: CurrencyService = CurrencyService()) {
        currencyService = service
    }
    
    func list() {
        
        self.dataManager.fetch(entity: Currency.self, completion: {error, model  in
            self.bindListAvaiableCurrencies?(error!)
        })
        currencyService.list { [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
                case .success(let model):
                    if let model = model, let currencies = model.currencies {
                        self.bindListAvaiableCurrencies?(currencies)
                        self.currencies = currencies
                        self.dataManager.insert(with: currencies, completion: nil)
                    }
                case.error(_):
                    self.handleOffilineList()
                    break
            }
        }
    }
    
    
    func filterList(by filter: SelectCurrencyFilter) {
        
        guard selectedFilter != filter else { return}
        
        bindLoadingState?()
        
        switch filter {
        case .byCode:
            bindListAvaiableCurrencies?(currenciesFilteredByCode)
        case .byName:
            bindListAvaiableCurrencies?(currenciesFIlteredByName)
        case .none:
            bindListAvaiableCurrencies?(currencies)
        }
        
        selectedFilter = filter
    }
    
    private func handleOffilineList() {
        dataManager.fetch(entity: Currency.self, completion: { [weak self] model, error  in
            guard let self = self else { return }
            
            if let error = error {
                //todo
                return
            }
            
            guard let currencies = model else {
                //TODSO
                return
            }
            self.currencies = currencies
            self.bindListAvaiableCurrencies?(currencies)
        })
    }
    
}
