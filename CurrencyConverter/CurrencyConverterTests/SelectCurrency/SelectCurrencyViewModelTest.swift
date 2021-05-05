//
//  SelectCurrencyViewModelTest.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import XCTest
@testable import CurrencyConverter

class SelectCurrencyViewModelTest: XCTestCase {
   
    var viewModel: SelectCurrencyViewModel!
    
    override func setUp() {
        DataManager.shared.delete(entityName: "Currency", completion: nil)
        DataManager.shared.resetUpdateDates()
    }
    
    func testGetListCurrenciesSuccesseful() {
        viewModel = SelectCurrencyViewModel(service: CurrencyServiceMock(shouldReturnError: false))
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertEqual(viewMock.resultAvaiableCurrencies.count, 5)
    }
    
    func testGetListCurrenciesWtihError() {
        viewModel = SelectCurrencyViewModel(service: CurrencyServiceMock(shouldReturnError: true))
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertEqual(viewMock.resultErrorStateText, "Your monthly usage limit has been reached. Please upgrade your subscription plan.")
    }
    
    func testLoadViewWasCalled() {
        viewModel = SelectCurrencyViewModel(service: CurrencyServiceMock(shouldReturnError: false))
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertTrue(viewMock.isLoadStateCalled)
    }

    func testFilterByCode() {
        viewModel = SelectCurrencyViewModel(service: CurrencyServiceMock(shouldReturnError: false))
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        let orderedArray: [Currency] = [Currency(code: "AED", name: "United Arab Emirates Dirham"),
                                        Currency(code: "AFN", name: "Afghan Afghani"),
                                        Currency(code: "ALL", name: "Albanian Lek"),
                                        Currency(code: "AMD", name: "Armenian Dram"),
                                        Currency(code: "ANG", name: "Netherlands Antillean Guilder"),]
        viewModel.list()
        viewModel.filterList(by: .byCode)
        
        let isEqual = viewMock.resultAvaiableCurrencies.elementsEqual(orderedArray) {
                $0.currencyCode == $1.currencyCode
        }
        XCTAssertTrue(isEqual)
    }
    
    func testFilterByName() {
        viewModel = SelectCurrencyViewModel(service: CurrencyServiceMock(shouldReturnError: false))
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        let orderedArray: [Currency] = [Currency(code: "AFN", name: "Afghan Afghani"),
                                        Currency(code: "ALL", name: "Albanian Lek"),
                                        Currency(code: "AMD", name: "Armenian Dram"),
                                        Currency(code: "ANG", name: "Netherlands Antillean Guilder"),
                                        Currency(code: "AED", name: "United Arab Emirates Dirham")]
        viewModel.list()
        viewModel.filterList(by: .byName)
        
        let isEqual = viewMock.resultAvaiableCurrencies.elementsEqual(orderedArray) {
                $0.currencyCode == $1.currencyCode
        }
        XCTAssertTrue(isEqual)
    }
}

