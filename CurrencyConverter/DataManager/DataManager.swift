//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import CoreData

/// Especialista em Core Data, gerencia os modos de insert, fetch, update e delete para todos as entitys
class DataManager {
    
    private lazy var dataController: DataController = {
        DataController()
    }()
    
    public var context: NSManagedObjectContext {
        dataController.manageContext
    }
    
    
    private init() {}
    
    public static let shared = DataManager()
}

// MARK: - Insert
extension DataManager {
    
    /// Inst.
    /// - Parameters:
    ///   - currency: Currency
    ///   - completion: (DataControllerError) -> Void)?
    func insert(with currencies: [Currency], completion: ((DataControllerError) -> Void)?) {
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
    
    /// Inst.
    /// - Parameters:
    ///   - currency: [String: Float]
    ///   - completion: (DataControllerError) -> Void)?
    func insert(with quotes: [String: Float], completion: ((DataControllerError) -> Void)?) {
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
    
    /// Busca todos os dados de qualquer entidade.
    /// - Parameters:
    ///   - entity: T.Type
    ///   - completion: ([T]?,DataControllerError?) -> Void)?
    func fetch<T: NSManagedObject>(entity: T.Type, completion: (([T]?,DataControllerError?) -> Void)?) {
        let dataController = self.dataController
        
        dataController.retrieveData(fetch: entity.fetchRequest(), handler: { results in
            completion?(results as? [T],nil)
        }) { error in
            completion?(nil,error)
        }
    }
    
}

