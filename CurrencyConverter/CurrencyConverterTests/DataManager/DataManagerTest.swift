//
//  DataManagerTest.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation
import XCTest
@testable import CurrencyConverter


final class DataManagerTest: XCTestCase {
    
    func testNeedsUpdateDataBaseFromServerEqualsTrue() {
        let yesterdayDate = Calendar.current.date(byAdding: .hour, value: -24, to: Date())
        DataManager.shared.hasUpdatedQuotes(in: yesterdayDate!.timeIntervalSince1970)
        XCTAssertTrue(DataManager.shared.needsUpdateQuotesFromServer)
    }
    
    func testNeedsUpdateDataBaseFromServerEqualsFalse() {
        let date = Date()
        DataManager.shared.hasUpdatedQuotes(in: date.timeIntervalSince1970)
        XCTAssertFalse(DataManager.shared.needsUpdateQuotesFromServer)
    }
}
