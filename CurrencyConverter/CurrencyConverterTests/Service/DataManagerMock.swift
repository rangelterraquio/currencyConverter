//
//  DataManagerMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 24/08/22.
//

import Foundation
import CoreData
@testable import CurrencyConverter

final class DataManagerMock: DataManagerProtocol {
    var needsUpdateCurrenciesListFromServer: Bool {
        return needsUpdateCurrencies
    }
    
    var needsUpdateQuotesFromServer: Bool {
        return needsUpdateQuotes
    }
    
    var needsUpdateCurrencies: Bool
    var needsUpdateQuotes: Bool
    var fetchWithError: Bool
    init(needsUpdateCurrencies: Bool, needsUpdateQuotes: Bool, fetchWithError: Bool = false) {
        self.needsUpdateCurrencies = needsUpdateCurrencies
        self.needsUpdateQuotes = needsUpdateQuotes
        self.fetchWithError = fetchWithError
    }
    func hasUpdatedCurrenciesList() {
        
    }
    
    func hasUpdatedQuotes(in date: TimeInterval) {
        
    }
    
    func resetUpdateDates() {
        
    }
    
    func insert(with currencies: [Currency], completion: ((DataControllerError?) -> Void)?) {
        
    }
    
    func insert(with quotes: [String : Float], completion: ((DataControllerError?) -> Void)?) {
        
    }
    
    func fetch<T>(entity: T.Type, completion: (([T]?, DataControllerError?) -> Void)?) where T : NSManagedObject {
        completion?(nil, nil)
    }
    
    func fetch<T>(entity: T.Type, predicate: NSPredicate, completion: (([T]?, DataControllerError?) -> Void)?) where T : NSManagedObject {
        if fetchWithError {
            completion?(nil, .InvalidSearch)
        }
        completion?([], nil)
    }
    
    func delete(entityName: String, completion: ((DataControllerError?) -> Void)?) {
        if fetchWithError {
            completion?(.InvalidSearch)
        }
        completion?(nil)
    }
    
    
}
