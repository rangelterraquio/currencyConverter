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

    private var error: CurrencyServiceError?

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
        bindLoadingState?()
        
        guard Connectivity.shared.isConnected else {
            error = .notConnected
            handleOffilineList()
            return
        }
        
        
        guard dataManager.needsUpdateCurrenciesListFromServer else {
            handleOffilineList()
            return
        }
        
        currencyService.list { [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
                case .success(let modelResult):
                    guard let model = modelResult, model.success, let currencies = model.currencies else {
                        self.error = modelResult?.error
                        self.handleOffilineList()
                        return
                    }
                        self.bindListAvaiableCurrencies?(currencies)
                        self.currencies = currencies
                        
                        
                        self.updateLocalDatabase(with: currencies)
                case.error(_):
                    self.error = .unkown
                    self.handleOffilineList()
            }
        }
    }
    
    private func updateLocalDatabase(with currencies: [Currency]) {
        dataManager.insert(with: currencies) { [weak self] (error) in
            
            guard error == nil else { return }
            
            self?.dataManager.hasUpdatedCurrenciesList()
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
            
            if let _ = error, let serviceError = self.error {
                self.bindErrorState?(serviceError.description)
                return
            }
            
            guard let currencies = model else {
                self.bindErrorState?(CurrencyServiceError.unkown.description)
                return
            }
            
            self.currencies = currencies
            self.bindListAvaiableCurrencies?(currencies)
        })
    }
}
