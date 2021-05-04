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
    public var bindErrorState: ((String)->Void)?
    
    private let dataManager = DataManager.shared
    
    private var currencies: [Currency] = []
    
    private var selectedFilter: SelectCurrencyFilter = .none

    private var error: CurrencyServiceError = .apiError

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
        
        guard Connectivity.shared.isConnected else {
            error = .connectioError
            handleOffilineList()
            return
        }
        
        currencyService.list { [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
                case .success(let model):
                    if let model = model, let currencies = model.currencies {
                        self.bindListAvaiableCurrencies?(currencies)
                        self.currencies = currencies
                        
                        if self.dataManager.currenciesListNeedsUpdate() {
                            self.dataManager.insert(with: currencies, completion: nil)
                            self.dataManager.hasUpdatedCurrenciesList()
                        }
                        return
                    }
                    self.error = .apiError
                    self.handleOffilineList()
                case.error(let errorModel):
                    if let response = errorModel?.response {
                        self.error = CurrencyServiceError(code: response.statusCode)
                    }
                    
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
    
    
    func search(for text: String?) {
        guard let text = text, !text.isEmpty else {
            self.bindListAvaiableCurrencies?(currencies)
            return
        }
        
        let predicate1 = NSPredicate(format: "currencyCode BEGINSWITH[cd] %@", text)
        let predicate2 = NSPredicate(format: "currencyName BEGINSWITH[cd] %@", text)

        let predicateOr = NSCompoundPredicate(type: .or, subpredicates: [predicate1, predicate2])
        dataManager.fetch(entity: Currency.self, predicate: predicateOr) { (model, error) in
            if let _ = error {
                self.bindListAvaiableCurrencies?([])
                return
            }
            
            guard let currencies = model else {
                self.bindListAvaiableCurrencies?([])
                return
            }
            self.bindListAvaiableCurrencies?(currencies)
        }
    }
    
    private func handleOffilineList() {
        dataManager.fetch(entity: Currency.self, completion: { [weak self] model, error  in
            guard let self = self else { return }
            
            if let _ = error {
                self.bindErrorState?(self.error.localizedDescription)
                return
            }
            
            guard let currencies = model else {
                self.bindErrorState?(self.error.localizedDescription)
                return
            }
            self.currencies = currencies
            self.bindListAvaiableCurrencies?(currencies)
        })
    }
    
}
