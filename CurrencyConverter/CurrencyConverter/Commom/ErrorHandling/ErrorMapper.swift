//
//  ErrorMapper.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

protocol ErrorMapperProtocol {
    func map(_ error: Error) -> AppError
    func map(_ msg: String) -> AppError
}

struct ErrorMapper: ErrorMapperProtocol {
    func map(_ error: Error) -> AppError {
        // Implement some error map
        guard let error = error as? AppError else {
            return AppErrorBase.unknown
        }
        
        return error
    }
    
    func map(_ msg: String) -> AppError {
        return AppErrorBase.custom(message: msg)
    }
}

protocol AppErrorHandlerProtocol {
    func handle(_ error: Error, context: String?)
    func handle(_ error: String, context: String?)
}

final class AppErrorHandler: AppErrorHandlerProtocol {
    
    static let shared = AppErrorHandler()
    
    let errorMapper: ErrorMapperProtocol = ErrorMapper()
    
    private init() {}

    func handle(_ error: Error, context: String? = nil) {
        let appError = errorMapper.map(error)
        logError(appError, context: context)
    }
    
    func handle(_ error: String, context: String? = nil) {
        let appError = errorMapper.map(error)
        logError(appError, context: context)
    }
    
    // MARK: - Implement some logger
    private func logError(_ error: Error, context: String?) {
        let logMessage = "[LOG] -> Error: \(error)"
        print(logMessage)
    }
}
