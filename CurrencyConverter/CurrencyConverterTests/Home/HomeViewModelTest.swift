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
        
        viewModel = HomeConvertViewModel(service:  CurrencyServiceMock(shouldReturnError: false), connectivity: ConnectivityMock())
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        viewModel.setFromCurrency(Currency(code: "AUD", name: "AUD"))
        viewModel.setToCurrency(Currency(code: "AWG", name: "AWG"))
        viewModel.convert(value: 50)
        
        let result = "50.0 AUD = 70.62 AWG"
        
        XCTAssertEqual(viewMock.resultConvertText, result)

    }
    
    func testConversionWithError() {
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: true), dataManager: DataManagerMock(needsUpdateCurrencies: true, needsUpdateQuotes: true, fetchWithError: true), connectivity: ConnectivityMock())
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.setFromCurrency(Currency(code: "AUD", name: "AUD"))
        viewModel.setToCurrency(Currency(code: "AWG", name: "AWG"))
        viewModel.convert(value: 50)
        
        let result = CurrencyServiceError(code: 201, description: "Something goes Wrong. Try Again!")
        
        XCTAssertEqual(viewMock.resultErrorStateText, result.description)

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
