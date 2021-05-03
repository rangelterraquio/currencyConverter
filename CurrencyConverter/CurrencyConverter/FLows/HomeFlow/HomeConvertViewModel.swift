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
    
    private let dataManager: DataManager
    
    init(service: CurrencyService = CurrencyService(), dataManager: DataManager = DataManager.shared) {
        self.currencyService = service
        self.dataManager = dataManager
    }
    
    func convert(from: Currency, to: Currency, value: Float) {
        
        currencyService.convert(value: value, from: from, to: to) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                if let response = model, let quotes = response.quotes {
                    let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
                    self.bindResultConversionModel?(text)
                    self.dataManager.insert(with: quotes, completion: nil)
                }
            case .error(_):
                self.handleConversionOffiline(value: value, from: from, to: to)
                break
            }
        }
    }
    
    private func handleConversionOffiline(value: Float, from: Currency, to: Currency) {
        dataManager.fetch(entity: Quotes.self) { (model, error) in
            if let _ = error {
                //TODO Error
                return
            }
            guard let model = model?.first, let quotes: [String: Float] = try? model.quotes?.decoded() else {
                return
            }
            let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
            self.bindResultConversionModel?(text)
            
        }
    }
    
    
    
    private func convertAndFormatText(value: Float, from: Currency, to: Currency, quotes: [String : Float]) -> String {
        
        guard let fromCode = from.currencyCode, let toCode = to.currencyCode else {
            //TODO
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
    }
}
