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
    
    init(service: CurrencyService = CurrencyService()) {
        currencyService = service
    }
    
    func convert(from: Currency, to: Currency, value: Float) {
        currencyService.convert(value: value, from: from, to: to) { [weak self] (result) in
            switch result {
            case .success(let model):
                if let response = model, let quotes = response.quotes, let self = self {
                    let text = self.convertAndFormatText(value: value, from: from, to: to, quotes: quotes)
                    self.bindResultConversionModel?(text)
                }
                
            case .error(let error):
                break
            }
        }
    }
    
    private func convertAndFormatText(value: Float, from: Currency, to: Currency, quotes: [String : Float]) -> String {
        let amountInDolar = (quotes["USD\(from.currencyCode)"] ?? 1) / value
        
        let conversion = (quotes["USD\(to.currencyCode)"] ?? 1) / amountInDolar
        
        return "\(value) \(from.currencyCode) = \(String(format: "%.2f", conversion)) \(to.currencyCode)"
    }
    
    func validateInputs(from: Currency?, to: Currency?, value: String?) {
        if let _ = from, let _ = to, let _ = Float.init(value ?? "") {
            bindValidatedInputs?(true)
            return
        }
        bindValidatedInputs?(false)
    }
}
