//
//  HomeViewConfigurator.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import UIKit

final class HomeViewConfigurator {
    
    weak var viewModel: HomeConvertViewModelProtocol?
    weak var homeView: HomeView?
    
    init(viewModel: HomeConvertViewModelProtocol, homeView: HomeView) {
        self.viewModel = viewModel
        self.homeView = homeView
        setupBindings()
        setupInitialState()
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        // Bind ViewModel to View
        viewModel.bindResultConversionModel = { [weak self] text in
            DispatchQueue.main.async {
                self?.updateViewState(isLoading: false, resultText: text)
            }
        }
        
        viewModel.bindValidatedInputs = { [weak self] isValid in
            DispatchQueue.main.async {
                self?.updateViewState(isConvertEnabled: isValid, errorText: nil)
            }
        }
        
        viewModel.bindErrorState = { [weak self] error in
            DispatchQueue.main.async {
                self?.updateViewState(isLoading: false, errorText: error)
            }
        }
    }
    
    private func setupInitialState() {
        guard let viewModel = viewModel else { return }
        
        let initialState = HomeViewState(
            isLoading: false,
            isConvertEnabled: false,
            resultText: nil,
            errorText: nil,
            fromCurrency: viewModel.getFromCurrency(),
            toCurrency: viewModel.getToCurrency()
        )
        
        homeView?.configure(with: initialState)
    }
    
    private func updateViewState(
        isLoading: Bool? = nil,
        isConvertEnabled: Bool? = nil,
        resultText: String? = nil,
        errorText: String? = nil,
        fromCurrency: Currency? = nil,
        toCurrency: Currency? = nil
    ) {
        guard let homeView = homeView else { return }
        
        // Get current state or create new one
        let currentState = getCurrentState()
        
        let newState = HomeViewState(
            isLoading: isLoading ?? currentState.isLoading,
            isConvertEnabled: isConvertEnabled ?? currentState.isConvertEnabled,
            resultText: resultText ?? currentState.resultText,
            errorText: errorText,
            fromCurrency: fromCurrency ?? currentState.fromCurrency,
            toCurrency: toCurrency ?? currentState.toCurrency
        )
        
        homeView.configure(with: newState)
    }
    
    private func getCurrentState() -> HomeViewState {
        guard let viewModel = viewModel else { return .initial }
        
        return HomeViewState(
            isLoading: false,
            isConvertEnabled: true,
            resultText: nil,
            errorText: nil,
            fromCurrency: viewModel.getFromCurrency(),
            toCurrency: viewModel.getToCurrency()
        )
    }
    
    func startConversion() {
        updateViewState(isLoading: true, errorText: nil)
    }
    
    func updateCurrencies(from: Currency?, to: Currency?) {
        updateViewState(fromCurrency: from, toCurrency: to)
    }
    
    func validateInputs() {
        guard let viewModel = viewModel else { return }
        
        let fromCurrency = viewModel.getFromCurrency()
        let toCurrency = viewModel.getToCurrency()
        
        viewModel.validateCurrencyInputs(from: fromCurrency, to: toCurrency, value: nil)
    }
} 
