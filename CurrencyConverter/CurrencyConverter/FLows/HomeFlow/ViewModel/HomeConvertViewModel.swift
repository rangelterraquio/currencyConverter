//
//  HomeConvertViewModel.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol HomeConvertViewModelProtocol: AnyObject {
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
    
    private let currencyService: CurrencyServiceProtocol
    private let dataManager: DataManagerProtocol
    private let connectivity: ConnectivityProtocol
    private let currencyConverter: CurrencyConverterProtocol
    private let inputValidator: InputValidatorProtocol
    private var stateManager: ConversionStateManagerProtocol
    private let errorHandler: AppErrorHandlerProtocol
    
    // MARK: - Bindings
    public var bindResultConversionModel: ((String)->Void)?
    public var bindValidatedInputs: ((Bool)->Void)?
    public var bindErrorState: ((String)->Void)?
    
    // MARK: - State
    private var fromCurrency: Currency?
    private var toCurrency: Currency?
    
    init(service: CurrencyServiceProtocol = CurrencyService.create(),
         dataManager: DataManagerProtocol = DataManager(),
         connectivity: ConnectivityProtocol = Connectivity.shared,
         currencyConverter: CurrencyConverterProtocol = CurrencyConverter(),
         inputValidator: InputValidatorProtocol = InputValidator(),
         stateManager: ConversionStateManagerProtocol = ConversionStateManager(),
         errorHandler: AppErrorHandlerProtocol = AppErrorHandler.shared) {
        
        self.currencyService = service
        self.dataManager = dataManager
        self.connectivity = connectivity
        self.currencyConverter = currencyConverter
        self.inputValidator = inputValidator
        self.stateManager = stateManager
        self.errorHandler = errorHandler
        
        super.init()
        
        setupDefaultCurrencies()
        setupStateObservation()
    }
    
    func convert(value: Float) {
        let validationResult = inputValidator.validateConversionInputs(
            value: String(value),
            from: fromCurrency,
            to: toCurrency
        )
        
        if !validationResult.isValid {
            handleValidationError(validationResult)
            return
        }
        
        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {
            handleConversionError(CurrencyConversionError.invalidCurrency)
            return
        }
        
        // Start conversion process
        stateManager.startLoading()
        
        if connectivity.isConnected && dataManager.needsUpdateQuotesFromServer {
            performOnlineConversion(value: value, from: fromCurrency, to: toCurrency)
        } else {
            performOfflineConversion(value: value, from: fromCurrency, to: toCurrency)
        }
    }
    
    func validateCurrencyInputs(from: Currency?, to: Currency?, value: String?) {
        let validationResult = inputValidator.validateConversionInputs(
            value: value,
            from: from,
            to: to
        )
        
        bindValidatedInputs?(validationResult.isValid)
    }
    
    func validateValueInput(value: String?) {
        let validationResult = inputValidator.validateValue(value)
        bindValidatedInputs?(validationResult.isValid)
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
    
    private func setupDefaultCurrencies() {
        let defaultFrom = HomeConstants.DefaultCurrencies.from
        let defaultTo = HomeConstants.DefaultCurrencies.to
        
        fromCurrency = Currency(code: defaultFrom.code, name: defaultFrom.name)
        toCurrency = Currency(code: defaultTo.code, name: defaultTo.name)
    }
    
    private func setupStateObservation() {
        stateManager.onStateChange = { [weak self] state in
            self?.handleStateChange(state)
        }
    }
    
    private func handleStateChange(_ state: ConversionState) {
        switch state {
        case .idle:
            break
        case .loading:
            break
        case .success(let result):
            let formattedResult = currencyConverter.formatConversionResult(result)
            bindResultConversionModel?(formattedResult)
        case .error(let message):
            bindErrorState?(message)
        }
    }
    
    private func performOnlineConversion(value: Float, from: Currency, to: Currency) {
        currencyService.convert(amount: value,
                                from: from.currencyCode ?? "",
                                to: to.currencyCode ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let modelResult):
                self.handleNetworkSuccess(modelResult, value: value, from: from, to: to)
            case .failure(let error):
                self.handleNetworkError(error, value: value, from: from, to: to)
            }
        }
    }
    
    private func handleNetworkSuccess(_ modelResult: ConversionResponseModel?, value: Float, from: Currency, to: Currency) {
        guard let model = modelResult, model.success, let quotes = model.quotes else {
            performOfflineConversion(value: value, from: from, to: to)
            return
        }
        
        // Perform conversion
        let conversionResult = currencyConverter.convert(value: value, from: from, to: to, quotes: quotes)
        
        if conversionResult.success {
            stateManager.setSuccess(result: conversionResult)
            updateLocalDatabase(with: quotes, date: model.timestamp ?? Date().timeIntervalSince1970)
        } else {
            let error = CurrencyConversionError.custom(message: conversionResult.errorMessage ?? "Unknown error")
            handleConversionError(error)
        }
    }
    
    private func handleNetworkError(_ error: (any Error)?, value: Float, from: Currency, to: Currency) {
        if let error = error {
            errorHandler.handle(error, context: "Online conversion failed")
        }
        
        // Fallback to offline conversion
        performOfflineConversion(value: value, from: from, to: to)
    }
    
    private func performOfflineConversion(value: Float, from: Currency, to: Currency) {
        dataManager.fetch(entity: Quotes.self) { [weak self] (model, error) in
            guard let self = self else { return }
            
            if let _ = error {
                self.handleConversionError(CurrencyConversionError.custom(message: "Failed to fetch Data"))
                return
            }
            
            guard let model = model?.first, let quotes: [String: Float] = try? model.quotes?.decoded() else {
                self.handleConversionError(CurrencyConversionError.custom(message: "Failed to fetch Data"))
                return
            }
            
            let conversionResult = self.currencyConverter.convert(value: value, from: from, to: to, quotes: quotes)
            
            if conversionResult.success {
                self.stateManager.setSuccess(result: conversionResult)
            } else {
                let error = CurrencyConversionError.custom(message: conversionResult.errorMessage ?? "Unknown error")
                self.handleConversionError(error)
            }
        }
    }
    
    private func updateLocalDatabase(with quotes: [String: Float], date: TimeInterval) {
        dataManager.insert(with: quotes) { [weak self] error in
            if let error = error {
                self?.errorHandler.handle(error, context: "Failed to update local database")
            } else {
                self?.dataManager.hasUpdatedQuotes(in: date)
            }
        }
    }
    
    private func handleValidationError(_ validationResult: ValidationResult) {
        errorHandler.handle(validationResult.errorMessage ?? "", context: "Validate conversion input")
    }
    
    private func handleConversionError(_ error: AppError) {
        errorHandler.handle(error, context: "Currency conversion")
        stateManager.setError(message: error.message)
    }
}
