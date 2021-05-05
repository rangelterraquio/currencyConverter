//
//  CoreDataController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import CoreData

// MARK: - DataControllerError Enum
public enum DataControllerError: Error {
    case NotFound
    case InvalidSearch
    case SaveError
    
}

// MARK: - DataController class
public class DataController {
    
    public lazy var manageContext: NSManagedObjectContext = {
        CoreDataStack.persistentContainer.viewContext
    }()
    
    private func save(context: NSManagedObjectContext) throws {
        do {
            try context.save()
        } catch {
            throw DataControllerError.SaveError
        }
    }
    
    private func fechRequest(with fechRequest: NSFetchRequest<NSFetchRequestResult>, context: NSManagedObjectContext) throws -> [NSManagedObject] {
        
        do {
            let result = try context.fetch(fechRequest)
            guard result.count > 0 else {
                throw DataControllerError.NotFound
            }
            return result as! [NSManagedObject]
        } catch {
            throw DataControllerError.InvalidSearch
        }
    }
}

// MARK: - DataController Insert
extension DataController {
    
    
    public func insertData(entity: String,  handler: @escaping (NSManagedObjectContext) -> Void, completion: @escaping ((DataControllerError?) -> Void)) {
        
        let context: NSManagedObjectContext = self.manageContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        
        do {
            try context.execute(deleteRequest)
            handler(context)
            try self.save(context: context)
            completion(nil)
        } catch {
            completion(DataControllerError.SaveError)
        }
    }
}

// MARK: - DataController Retrive
extension DataController {
    
    public func retrieveData(fetch: NSFetchRequest<NSFetchRequestResult>, handler: @escaping ([NSManagedObject]) -> Void, completion: ((DataControllerError?) -> Void)?) {
        
        do{
            let results = try self.fechRequest(with: fetch, context: self.manageContext)
            handler(results)
        } catch DataControllerError.InvalidSearch {
            completion?(DataControllerError.InvalidSearch)
        } catch {
            completion?(DataControllerError.NotFound)
        }
    }
    
    public func retrieveData(predicate: NSPredicate, fetch: NSFetchRequest<NSFetchRequestResult>, handler: @escaping ([NSManagedObject]) -> Void, completion: ((DataControllerError) -> Void)?) {
        
        let context: NSManagedObjectContext = self.manageContext
        fetch.predicate =  predicate
        
        do{
            let results = try self.fechRequest(with: fetch, context: context)
            handler(results)
        } catch DataControllerError.InvalidSearch {
            completion?(DataControllerError.InvalidSearch)
        } catch {
            completion?(DataControllerError.NotFound)
        }
    }
}

extension DataController {
    
    public func deleteAllData(entity: String, completion: ((DataControllerError) -> Void)?) {
        
        let context: NSManagedObjectContext = self.manageContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        
        do {
            try context.execute(deleteRequest)
            try self.save(context: context)
            
        } catch {
            completion?(DataControllerError.SaveError)
        }
    }
}
