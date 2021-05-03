//
//  CoreDataController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import CoreData

// MARK: - DataControllerError Enum
/// Enum que fornece os tipos de erros encontrados no processo de *save* e  *fetch* no banco de dados.
public enum DataControllerError: Error {
    case NotFound
    case InvalidSearch
    case SaveError

}

// MARK: - DataController class
/// DataController gerencia a funções necessarias para entrar em contato.
public class DataController {
    
    /// Salva o contexto do banco de dados.
    public lazy var manageContext: NSManagedObjectContext = {
        CoreDataStack.persistentContainer.viewContext
    }()
    
    
    /// Responsavel por salvar no contexto fornecido.
    /// - Parameter context: NSManagedObjectContext
    /// - Throws: DataControllerError.SaveError
    private func save(context: NSManagedObjectContext) throws {
        
        do {
            try context.save()
        } catch {
            throw DataControllerError.SaveError
        }
        
    }
    
    /// Responsável por fazer a busca no banco de dados.
    /// Caso retorne um array vazio, é enviado um erro DataControllerError.NotFound para quem chamou a função.
    /// - Parameters:
    ///   - fechRequest: NSFetchRequest<NSFetchRequestResult>
    ///   - context: NSManagedObjectContext
    /// - Throws: DataControllerError.NotFound & DataControllerError.InvalidSearch
    /// - Returns: [NSManagedObject]
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
    
    /// Insere no banco de dados.
    /// Caso algo der errado no momento de salvar, a completion é chamado com um argumento DataControllerError.SaveError.
    /// - Parameters:
    ///   - handler: @escaping (NSManagedObjectContext) -> Void
    ///   - completion: ((Error?) -> Void)?
    public func insertData(entity: String,  handler: @escaping (NSManagedObjectContext) -> Void, completion: ((DataControllerError) -> Void)?){
        
        let context: NSManagedObjectContext = self.manageContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        
        do {
            try context.execute(deleteRequest)
            handler(context)
            try self.save(context: context)
            
        } catch {
            completion?(DataControllerError.SaveError)
        }
        
    }
    
    
}

// MARK: - DataController Retrive
extension DataController {
    
    /// Busca no banco de dados.
    /// Caso não encontre nem um *objetc*, o complition passa como argumento o erro DataControllerError.NotFound.
    /// - Parameters:
    ///   - fetch: NSFetchRequest<NSFetchRequestResult>
    ///   - handler: @escaping ([NSManagedObject]) -> Void
    ///   - completion: ((Error?) -> Void)?
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
}
