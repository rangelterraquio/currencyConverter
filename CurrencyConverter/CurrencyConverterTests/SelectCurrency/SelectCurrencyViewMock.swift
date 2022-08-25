//
//  SelectCurrencyViewMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation
@testable import CurrencyConverter

class SelectCurrencyViewMock {
    
    let viewModel: SelectCurrencyViewModel
    
    var resultAvaiableCurrenciesCalled: Bool = false
    var resultErrorStateText: String = ""
    var isLoadStateCalled: Bool = false
    
    init(viewModel: SelectCurrencyViewModel) {
        self.viewModel = viewModel
        setup()
    }
    
    func setup() {
        viewModel.bindListAvaiableCurrencies = {
            self.resultAvaiableCurrenciesCalled = true
        }
        
        viewModel.bindErrorState = { error in
            self.resultErrorStateText = error
        }
        
        viewModel.bindLoadingState = {
            self.isLoadStateCalled = true
        }
    }
}
