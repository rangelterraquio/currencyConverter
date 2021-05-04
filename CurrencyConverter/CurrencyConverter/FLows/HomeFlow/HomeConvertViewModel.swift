//
//  HomeConvertViewModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

class HomeConvertViewModel: NSObject {
    
    private let currencyService: CurrencyService
    
    public var bindResultConversionModel: ((String)->Void)?
    
    public var bindValidatedInputs: ((Bool)->Void)?
    
    public var bindErrorState: ((String)->Void)?
    
    private let dataManager: DataManager
   
    private var error: CurrencyServiceError = .apiError
    
    init(service: CurrencyService = CurrencyService(), dataManager: DataManager = DataManager.shared) {
        self.currencyService = service
        self.dataManager = dataManager
    }
    
    func convert(from: Currency, to: Currency, value: Float) {
        
        guard Connectivity.shared.isConnected else {
            error = .connectioError
            handleConversionOffiline(value: value, from: from, to: to)
            return
        }
        
        currencyService.convert() { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                if let response = model, let quotes = response.quotes {
                    let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
                    self.bindResultConversionModel?(text)
                    
                    if self.dataManager.quotesNeedsUpdate(lastDateCollected: response.timestamp) {
                        self.dataManager.insert(with: quotes, completion: nil)
                        self.dataManager.hasUpdatedQuotes(in: response.timestamp)
                    }
                    return
                }
                
                self.error = .apiError
                self.handleConversionOffiline(value: value, from: from, to: to)

            case .error(let errorModel):
                if let response = errorModel?.response {
                    self.error = CurrencyServiceError(code: response.statusCode)
                }
                self.handleConversionOffiline(value: value, from: from, to: to)
                break
            }
        }
    }
    
    private func handleConversionOffiline(value: Float, from: Currency, to: Currency) {
        dataManager.fetch(entity: Quotes.self) { [weak self] (model, error) in
            guard let self = self else { return }
            
            if let _ = error {
                self.bindErrorState?(self.error.localizedDescription)
                return
            }
            
            guard let model = model?.first, let quotes: [String: Float] = try? model.quotes?.decoded() else {
                self.bindErrorState?(self.error.localizedDescription)
                return
            }
            
            let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
            self.bindResultConversionModel?(text)
            
        }
    }
    
    
    private func convertAndFormatText(value: Float, from: Currency, to: Currency, quotes: [String : Float]) -> String {
        
        guard let fromCode = from.currencyCode, let toCode = to.currencyCode else {
            bindErrorState?(CurrencyServiceError.invalidCurrencies.localizedDescription)
            return ""
        }
        let amountInDolar = (quotes["USD\(fromCode)"] ?? 1) / value
        
        let conversion = (quotes["USD\(toCode)"] ?? 1) / amountInDolar
        
        return "\(value) \(fromCode) = \(String(format: "%.2f", conversion)) \(toCode)"
    }
    
    func validateInputs(from: Currency?, to: Currency?, value: String?) {
        if let _ = from, let _ = to, let _ = Float.init(value ?? "") {
            bindValidatedInputs?(true)
            return
        }
        bindValidatedInputs?(false)
        bindErrorState?(CurrencyServiceError.invalidAmount.localizedDescription)
    }
}
