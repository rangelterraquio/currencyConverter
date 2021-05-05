//
//  HomeViewMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 04/05/21.
//

import Foundation
@testable import CurrencyConverter

class HomeViewMock {
    
    let viewModel: HomeConvertViewModel
    
    var resultConvertText: String = ""
    var resultErrorStateText: String = ""
    var resultIsValidInputs: Bool = false
    
    init(viewModel: HomeConvertViewModel) {
        self.viewModel = viewModel
        setup()
    }
    
    func setup() {
        viewModel.bindResultConversionModel = { result in
            self.resultConvertText = result
        }
        
        viewModel.bindErrorState = { error in
            self.resultErrorStateText = error
        }
        
        viewModel.bindValidatedInputs = { isValid in
            self.resultIsValidInputs = isValid
        }
    }
}

