//
//  HomeConvertViewModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol HomeConvertViewModelProtocol {
    var bindResultConversionModel: ((String)->Void)? { get set }
    var bindValidatedInputs: ((Bool)->Void)? { get set }
    var bindErrorState: ((String)->Void)? { get set }
    
    func convert(value: Float)
    func validateCurrencyInputs(from: Currency?, to: Currency?, value: String?)
    func setFromCurrency(_ fromCurrency: Currency?)
    func setToCurrency(_ toCurrency: Currency?)
    func getFromCurrency() -> Currency?
    func getToCurrency() -> Currency?
    func validateValueInput(value: String?)
}

final class HomeConvertViewModel: NSObject, HomeConvertViewModelProtocol {
    
    //MARK: - Properties
    private let currencyService: CurrencyServiceProtocol
    
    public var bindResultConversionModel: ((String)->Void)?
    
    public var bindValidatedInputs: ((Bool)->Void)?
    
    public var bindErrorState: ((String)->Void)?
    
    var dataManager: DataManagerProtocol
    var connectivity: ConnectivityProtocol
    
    private var error: CurrencyServiceError?
    
    private var fromCurrency: Currency? = Currency(code: "BRL", name: "Brazilian Real")
    
    private var toCurrency: Currency? = Currency(code: "USD", name: "United States Dollar")
    
    //MARK: - Init
    init(service: CurrencyServiceProtocol = CurrencyService(),
         dataManager: DataManagerProtocol = DataManager(),
         connectivity: ConnectivityProtocol = Connectivity.shared) {
        self.currencyService = service
        self.dataManager = dataManager
        self.connectivity = connectivity
    }
    
    func convert(value: Float) {
        guard let from = fromCurrency, let to = toCurrency else {
            bindErrorState?("Invalid selected currencies")
            return
        }
        
        guard connectivity.isConnected else {
            error = .notConnected
            handleConversionOffiline(value: value, from: from, to: to)
            return
        }
        /*
         As the free version of the APP only updates the values daily
         for a better use of the API it just get data from the server once a day.
         */
        guard dataManager.needsUpdateQuotesFromServer else {
            handleConversionOffiline(value: value, from: from, to: to)
            return
        }
        
        currencyService.convert() { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let modelResult):
                guard let model = modelResult, model.success, let quotes = model.quotes else {
                    self.error = modelResult?.error
                    self.handleConversionOffiline(value: value, from: from, to: to)
                    return
                }
                
                let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
                self.bindResultConversionModel?(text)
                self.updateLocalDatabase(with: quotes, date: model.timestamp ?? Date().timeIntervalSinceNow)
            case .error(_):
                self.error = .unkown
                self.handleConversionOffiline(value: value, from: from, to: to)
                break
            }
        }
    }
    
    private func updateLocalDatabase(with quotes: [String : Float], date: TimeInterval) {
        dataManager.insert(with: quotes) { [weak self] (error) in
            
            guard error == nil else { return }
            
            self?.dataManager.hasUpdatedQuotes(in: date)
        }
    }
    
    private func handleConversionOffiline(value: Float, from: Currency, to: Currency) {
        dataManager.fetch(entity: Quotes.self) { [weak self] (model, error) in
            guard let self = self else { return }
            
            if let _ = error, let serviceError = self.error {
                self.bindErrorState?(serviceError.description)
                return
            }
            
            guard let model = model?.first, let quotes: [String: Float] = try? model.quotes?.decoded() else {
                self.bindErrorState?(CurrencyServiceError.unkown.description)
                return
            }
            
            let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
            self.bindResultConversionModel?(text)
        }
    }
    
    private func convertAndFormatText(value: Float, from: Currency, to: Currency, quotes: [String : Float]) -> String {
        
        guard let fromCode = from.currencyCode, let toCode = to.currencyCode else {
            bindErrorState?(CurrencyServiceError.invalidCurrencies.description)
            return ""
        }
        let amountInDolar = (quotes["USD\(fromCode)"] ?? 1) / value
        
        let conversion = (quotes["USD\(toCode)"] ?? 1) / amountInDolar
        
        return "\(value) \(fromCode) = \(String(format: "%.2f", conversion)) \(toCode)"
    }
    
    func validateCurrencyInputs(from: Currency?, to: Currency?, value: String?) {
        if let _ = from, let _ = to {
            bindValidatedInputs?(true)
            return
        }
        bindValidatedInputs?(false)
    }
    
    func validateValueInput(value: String?) {
        if let _ = Float.init(value ?? "") {
            bindValidatedInputs?(true)
            return
        }
        bindValidatedInputs?(false)
    }
    
    func setFromCurrency(_ fromCurrency: Currency?) {
        self.fromCurrency = fromCurrency
    }
    
    func setToCurrency(_ toCurrency: Currency?) {
        self.toCurrency = toCurrency
    }
    
    func getFromCurrency() -> Currency? {
        return fromCurrency
    }
    
    func getToCurrency() -> Currency? {
        return toCurrency
    }
}
