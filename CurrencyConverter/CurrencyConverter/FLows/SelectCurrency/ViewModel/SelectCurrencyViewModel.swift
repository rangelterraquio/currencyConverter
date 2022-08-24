//
//  SelectCurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

public enum CurrencySource {
    case from
    case to
}

protocol SelectCurrencyViewModelProtocol {
    var bindListAvaiableCurrencies: (([Currency]) -> Void)? { get set }
    var bindLoadingState: (() -> Void)? { get set }
    var bindErrorState: ((String)->Void)? { get set }
    var bindConfirmButtonState: ((Bool) -> Void)? { get set }
    
    func getCurrencySource() -> CurrencySource
    func getNumberOfCurrencies() -> Int
    func getCurrency(at index: Int) -> Currency? 
    func didSelectCurrency(at index: Int)
    func didDeselectCurrency(at index: Int)
    func getSelectedCurrency() -> Currency?
    func list()
    func filterList(by filter: SelectCurrencyFilter)
    func search(for text: String?)
}
final class SelectCurrencyViewModel: NSObject, SelectCurrencyViewModelProtocol {
    
    private let currencyService: CurrencyService
    
    public var bindListAvaiableCurrencies: (([Currency]) -> Void)?
    public var bindLoadingState: (() -> Void)?
    public var bindErrorState: ((String)->Void)?
    public var bindConfirmButtonState: ((Bool) -> Void)?
    
    private let dataManager = DataManager.shared
    
    private var currencies: [Currency] = []
    private var allCurrencies: [Currency] = []
    private var selectedCurrency: Currency?
    private let currencySource: CurrencySource
    
    private var selectedFilter: SelectCurrencyFilter = .none

    private var error: CurrencyServiceError?

    private var currenciesFilteredByCode: [Currency] {
        currencies.sorted { $0.currencyCode ?? "" < $1.currencyCode ?? "" }
    }
    
    private var currenciesFIlteredByName: [Currency] {
        currencies.sorted { $0.currencyName ?? "" < $1.currencyName ?? "" }
    }
    
    init(currencySource: CurrencySource,   service: CurrencyService = CurrencyService()) {
        self.currencySource =  currencySource
        self.currencyService = service
    }
    
    func getCurrencySource() -> CurrencySource {
        return currencySource
    }
    
    func getNumberOfCurrencies() -> Int {
        return currencies.count
    }
    
    func getCurrency(at index: Int) -> Currency? {
        guard index >= 0 && index < currencies.count else { return nil }
        
        return currencies[index]
    }
    
    func didSelectCurrency(at index: Int) {
        selectedCurrency = currencies[index]
        bindConfirmButtonState?(true)
    }
    
    func didDeselectCurrency(at index: Int) {
        if selectedCurrency ==  currencies[index] {
            selectedCurrency = nil
            bindConfirmButtonState?(false)
        }
    }
    
    func getSelectedCurrency() -> Currency? {
        return selectedCurrency
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
                        self.currencies = currencies
                        self.allCurrencies = currencies
                        self.bindListAvaiableCurrencies?(currencies)

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
        
        guard selectedFilter != filter else { return }
        
        bindLoadingState?()
        
        switch filter {
        case .byCode:
             currencies = currenciesFilteredByCode
        case .byName:
             currencies = currenciesFIlteredByName
        case .none:
            currencies = allCurrencies
        }
        
        selectedFilter = filter
        bindListAvaiableCurrencies?(currencies)
    }
    
    
    func search(for text: String?) {
        guard let text = text, !text.isEmpty else {
            self.currencies = allCurrencies
            self.bindListAvaiableCurrencies?(currencies)
            return
        }
        
        let predicate1 = NSPredicate(format: "currencyCode BEGINSWITH[cd] %@", text)
        let predicate2 = NSPredicate(format: "currencyName BEGINSWITH[cd] %@", text)

        let predicateOr = NSCompoundPredicate(type: .or, subpredicates: [predicate1, predicate2])
        dataManager.fetch(entity: Currency.self, predicate: predicateOr) { (model, error) in
            if let _ = error {
                self.currencies = []
                self.bindListAvaiableCurrencies?([])
                return
            }
            
            guard let currenciesFetched = model else {
                self.currencies = []
                self.bindListAvaiableCurrencies?([])
                return
            }
            self.currencies = currenciesFetched
            self.bindListAvaiableCurrencies?(currenciesFetched)
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
            self.allCurrencies = currencies
            self.currencies = currencies
            self.bindListAvaiableCurrencies?(currencies)
        })
    }
}
