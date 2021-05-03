//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation
import CoreData
//{
//    "success": true,
//    "terms": "https://currencylayer.com/terms",
//    "privacy": "https://currencylayer.com/privacy",
//    "currencies": {
//        "AED": "United Arab Emirates Dirham",
//        "AFN": "Afghan Afghani",
//        "ALL": "Albanian Lek",
//        "AMD": "Armenian Dram",
//        "ANG": "Netherlands Antillean Guilder",
//        [...]
//    }
//}

//
class Currency: NSManagedObject {
    
    convenience init(code: String, name: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Currency", in: DataManager.shared.context) else {  fatalError("Failed to decode Subject!")  }

        self.init(entity: entity, insertInto: nil)
        self.currencyCode = code
        self.currencyName = name
    }
}
//
//extension Currency {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
//        return NSFetchRequest<Currency>(entityName: "Currency")
//    }
//
//    @NSManaged public var currencyCode: String
//    @NSManaged public var currencyName: String
//}

//extension Currency: Equatable {
//    static func ==(lhs: Currency, rhs: Currency) -> Bool {
//        return lhs.currencyCode == rhs.currencyCode && lhs.currencyName == rhs.currencyName
//    }
//}


//extension Currency {
////
////    @NSManaged public var currencyCode: String
////    @NSManaged public var currencyName: String
//////
//    convenience init(code: String, name: String) {
//        self.init()
//        self.currencyCode = code
//        self.currencyName = name
//    }
//}


struct CurrenciesResponseModel: Codable {
    private var _currencies: [String : String]?
    var success: Bool
    var currencies: [Currency]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        _currencies = try? values.decode([String:String].self, forKey: ._currencies)
        
        defer { setCurrenciesModel() }
    }
    private mutating func setCurrenciesModel() {
        self.currencies = _currencies?.map({ Currency(code: $0.key, name: $0.value)}) ?? []
    }
   
    private enum CodingKeys: String, CodingKey  {
        case _currencies = "currencies"
        case success = "success"
    }
}
