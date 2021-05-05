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
    
    override func setUp() {
        DataManager.shared.delete(entityName: "Quotes", completion: nil)
        DataManager.shared.resetUpdateDates()
    }
    
    func testConversionWithSuccess() {
        
        viewModel = HomeConvertViewModel(service:  CurrencyServiceMock(shouldReturnError: false))
        
        let viewMock = HomeViewMock(viewModel: viewModel)
       
        viewModel.convert(from: Currency(code: "AUD", name: "AUD"), to: Currency(code: "AWG", name: "AWG"), value: 50)
        
        let result = "50.0 AUD = 70.62 AWG"
        
        XCTAssertEqual(viewMock.resultConvertText, result)

    }
    
    func testConversionWithError() {
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: true), dataManager: .shared)
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.convert(from: Currency(code: "AUD", name: "AUD"), to: Currency(code: "AWG", name: "AWG"), value: 50)
        
        let result = CurrencyServiceError(code: 201, description: "You have supplied an invalid Source Currency. [Example: source=EUR]")
        
        XCTAssertEqual(viewMock.resultErrorStateText, result.description)

    }
    
    func testConversionWithInvalidInputs() {
        viewModel = HomeConvertViewModel(service: CurrencyServiceMock(shouldReturnError: false), dataManager: .shared)
        
        let viewMock = HomeViewMock(viewModel: viewModel)
        
        viewModel.convert(from: Currency(code: "AUD", name: "AUD"), to: Currency(code: nil, name: "AWG"), value: 50)
                
        XCTAssertFalse(viewMock.resultIsValidInputs)

    }
}
