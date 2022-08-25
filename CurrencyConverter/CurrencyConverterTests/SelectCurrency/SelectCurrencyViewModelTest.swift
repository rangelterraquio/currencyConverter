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
    
    func testGetListCurrenciesSuccesseful() {
        viewModel = SelectCurrencyViewModel(currencySource: .to, service: CurrencyServiceMock(shouldReturnError: false), connectivity: ConnectivityMock())
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertTrue(viewMock.resultAvaiableCurrenciesCalled)
    }
    
    func testGetListCurrenciesWtihError() {
        viewModel = SelectCurrencyViewModel(currencySource: .to, service: CurrencyServiceMock(shouldReturnError: true), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true, fetchWithError: true), connectivity: ConnectivityMock())
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertEqual(viewMock.resultErrorStateText, "Something goes Wrong. Try Again!")
    }
    
    func testLoadViewWasCalled() {
        viewModel = SelectCurrencyViewModel(currencySource: .from, service: CurrencyServiceMock(shouldReturnError: false), connectivity: ConnectivityMock())
        
        let viewMock = SelectCurrencyViewMock(viewModel: viewModel)
        
        viewModel.list()
        
        XCTAssertTrue(viewMock.isLoadStateCalled)
    }

    func testFilterByCode() {
        viewModel = SelectCurrencyViewModel(currencySource: .from, service: CurrencyServiceMock(shouldReturnError: false), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true), connectivity: ConnectivityMock())
                
        let orderedArray: [Currency] = [Currency(code: "AED", name: "United Arab Emirates Dirham"),
                                        Currency(code: "AFN", name: "Afghan Afghani"),
                                        Currency(code: "ALL", name: "Albanian Lek"),
                                        Currency(code: "AMD", name: "Armenian Dram"),
                                        Currency(code: "ANG", name: "Netherlands Antillean Guilder"),]
        viewModel.list()
        viewModel.filterList(by: .byCode)
        
        var isEqual = true
        for (i, currency) in orderedArray.enumerated() {
            isEqual = currency.currencyName == (viewModel.getCurrency(at: i)?.currencyName ?? "")
        }
        
        XCTAssertTrue(isEqual)
    }
    
    func testFilterByName() {
        viewModel = SelectCurrencyViewModel(currencySource: .from, service: CurrencyServiceMock(shouldReturnError: false), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true), connectivity: ConnectivityMock())
                
        let orderedArray: [Currency] = [Currency(code: "AFN", name: "Afghan Afghani"),
                                        Currency(code: "ALL", name: "Albanian Lek"),
                                        Currency(code: "AMD", name: "Armenian Dram"),
                                        Currency(code: "ANG", name: "Netherlands Antillean Guilder"),
                                        Currency(code: "AED", name: "United Arab Emirates Dirham")]
        viewModel.list()
        viewModel.filterList(by: .byName)
        
        var isEqual = true
        for (i, currency) in orderedArray.enumerated() {
            isEqual = currency.currencyName == (viewModel.getCurrency(at: i)?.currencyName ?? "")
        }
        XCTAssertTrue(isEqual)
    }
}

