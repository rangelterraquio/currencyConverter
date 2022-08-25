//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    var needsUpdateCurrenciesListFromServer: Bool { get }
    var needsUpdateQuotesFromServer: Bool { get }
    
    func hasUpdatedCurrenciesList()
    func hasUpdatedQuotes(in date: TimeInterval)
    func resetUpdateDates()
    
    ///Insert
    func insert(with currencies: [Currency], completion: ((DataControllerError?) -> Void)?)
    func insert(with quotes: [String: Float], completion: ((DataControllerError?) -> Void)?)
    
    ///Fetch
    func fetch<T: NSManagedObject>(entity: T.Type, completion: (([T]?,DataControllerError?) -> Void)?)
    func fetch<T: NSManagedObject>(entity: T.Type,predicate: NSPredicate, completion: (([T]?,DataControllerError?) -> Void)?)
    
    ///Delete
    func delete(entityName: String, completion: ((DataControllerError?) -> Void)?)
}

class DataManager: DataManagerProtocol {
    
    private lazy var dataController: DataController = {
        DataController()
    }()
    
    var context: NSManagedObjectContext {
        dataController.manageContext
    }
        
    init() {}
    
    var needsUpdateCurrenciesListFromServer: Bool {
        if let lastUpdate = UserDefaults.lastCurrenciesListUpdate {
            return Calendar.current.isDateInYesterday(lastUpdate)
        }
        return true
    }
    
    var needsUpdateQuotesFromServer: Bool {
        if let lastUpdate = UserDefaults.lastQuotesUpdate {
            return Calendar.current.isDateInYesterday(lastUpdate)
        }
        return true
    }
    
    func hasUpdatedCurrenciesList() {
        UserDefaults.lastCurrenciesListUpdate = Date()
    }
    
    func hasUpdatedQuotes(in date: TimeInterval) {
        UserDefaults.lastQuotesUpdate = Date(timeIntervalSince1970: date)
    }
    
    func resetUpdateDates() {
        UserDefaults.lastQuotesUpdate = nil
        UserDefaults.lastCurrenciesListUpdate = nil
    }
}

// MARK: - Insert
extension DataManager {
    
    
    func insert(with currencies: [Currency], completion: ((DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.insertData(entity: "Currency", handler: { (context) in
            currencies.forEach { (currency) in
                let newCurrency = Currency(context: context)
                newCurrency.currencyCode = currency.currencyCode
                newCurrency.currencyName = currency.currencyName
            }
        }) { error in
            completion?(error)
        }
    }
    
    func insert(with quotes: [String: Float], completion: ((DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.insertData(entity: "Quotes", handler: { (context) in
            let entityDescription = NSEntityDescription.entity(forEntityName: "Quotes", in: context)
            let data = Quotes(entity: entityDescription!, insertInto: context)
            let dataModel = try? quotes.encoded()
            data.quotes = dataModel
        }) { error in
            completion?(error)
        }
    }
    

}

// MARK: - Fetch
extension DataManager {
    
    func fetch<T: NSManagedObject>(entity: T.Type, completion: (([T]?,DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.retrieveData(fetch: entity.fetchRequest(), handler: { results in
            completion?(results as? [T],nil)
        }) { error in
            completion?(nil,error)
        }
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type,predicate: NSPredicate, completion: (([T]?,DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.retrieveData(predicate: predicate, fetch: entity.fetchRequest(), handler: { results in
            completion?(results as? [T],nil)
        }) { error in
            completion?(nil,error)
        }
    }
    
}

//MARK: Delete
extension DataManager {
    
    func delete(entityName: String, completion: ((DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.deleteAllData(entity: entityName, completion: completion)
    }
}

