//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation
import CoreData

class Currency: NSManagedObject {
    
    convenience init(code: String?, name: String?) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Currency", in: DataManager().context) else {  fatalError("Failed to decode Subject!")  }

        self.init(entity: entity, insertInto: nil)
        self.currencyCode = code
        self.currencyName = name
    }
}

struct CurrenciesResponseModel: Decodable {
    private var _currencies: [String : String]?
    var success: Bool
    var currencies: [Currency]?
    let error: CurrencyServiceError?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        _currencies = try? values.decode([String:String].self, forKey: ._currencies)
        error = try? values.decode(CurrencyServiceError.self, forKey: .error)
        
        defer { setCurrenciesModel() }
    }
    private mutating func setCurrenciesModel() {
        self.currencies = _currencies?.map({ Currency(code: $0.key, name: $0.value)}) ?? []
    }
   
    private enum CodingKeys: String, CodingKey  {
        case _currencies = "currencies"
        case success = "success"
        case error
    }
}
