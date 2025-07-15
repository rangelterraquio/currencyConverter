//
//  HomeViewModelTest.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import XCTest
@testable import CurrencyConverter

class HomeViewModelTest: XCTestCase {

    var viewModel: HomeConvertViewModel!
    
    func testConversionWithSuccess() {
        let expectation = XCTestExpectation(description: "Currency conversion completes successfully")
        
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: false), connectivity: ConnectivityMock())
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.bindResultConversionModel = { result in
            viewMock.resultConvertText = result
            expectation.fulfill()
        }
        
        viewModel.setFromCurrency(Currency(code: "AUD", name: "AUD"))
        viewModel.setToCurrency(Currency(code: "AWG", name: "AWG"))
        viewModel.convert(value: 50)
        
        wait(for: [expectation], timeout: 3.0)
        
        let expectedResult = "50.00 AUD = 70.62 AWG"
        XCTAssertEqual(viewMock.resultConvertText, expectedResult)
    }
    
    func testConversionWithError() {
        let expectation = XCTestExpectation(description: "Currency conversion fails with error")
        
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: true), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true, fetchWithError: true), connectivity: ConnectivityMock())
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.bindErrorState = { error in
            viewMock.resultErrorStateText = error
            expectation.fulfill()
        }
        
        viewModel.setFromCurrency(Currency(code: "AUD", name: "AUD"))
        viewModel.setToCurrency(Currency(code: "AWG", name: "AWG"))
        viewModel.convert(value: 50)
        
        wait(for: [expectation], timeout: 3.0)
        
        let expectedError = "Failed to fetch Data"
        XCTAssertEqual(viewMock.resultErrorStateText, expectedError)
    }
    
    func testConversionWithInvalidInputs() {
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: false), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true), connectivity: ConnectivityMock())
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.setFromCurrency(Currency(code: "AUD", name: "AUD"))
        viewModel.setToCurrency(Currency(code: "AWG", name: "AWG"))
        viewModel.convert(value: 50)
                
        XCTAssertFalse(viewMock.resultIsValidInputs)
    }
}
