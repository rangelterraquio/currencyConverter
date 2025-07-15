//
//  ConversionStateManager.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

// MARK: - Conversion State
enum ConversionState {
    case idle
    case loading
    case success(result: CurrencyConversionResult)
    case error(message: String)
}

// MARK: - ConversionStateManager Protocol
protocol ConversionStateManagerProtocol {
    var onStateChange: ((ConversionState) -> Void)? { get set }
    var currentState: ConversionState { get }
    
    func setState(_ state: ConversionState)
    func reset()
    func startLoading()
    func setSuccess(result: CurrencyConversionResult)
    func setError(message: String)
}

// MARK: - ConversionStateManager Implementation
final class ConversionStateManager: ConversionStateManagerProtocol {
    
    // MARK: - Properties
    var onStateChange: ((ConversionState) -> Void)?
    
    private(set) var currentState: ConversionState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onStateChange?(self.currentState)
            }
        }
    }
    
    // MARK: - Public Methods
    func setState(_ state: ConversionState) {
        currentState = state
    }
    
    func reset() {
        currentState = .idle
    }
    
    func startLoading() {
        currentState = .loading
    }
    
    func setSuccess(result: CurrencyConversionResult) {
        currentState = .success(result: result)
    }
    
    func setError(message: String) {
        currentState = .error(message: message)
    }
    
    // MARK: - Computed Properties
    var isLoading: Bool {
        switch currentState {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var hasError: Bool {
        switch currentState {
        case .error:
            return true
        default:
            return false
        }
    }
    
    var errorMessage: String? {
        switch currentState {
        case .error(let message):
            return message
        default:
            return nil
        }
    }
    
    var conversionResult: CurrencyConversionResult? {
        switch currentState {
        case .success(let result):
            return result
        default:
            return nil
        }
    }
} 
