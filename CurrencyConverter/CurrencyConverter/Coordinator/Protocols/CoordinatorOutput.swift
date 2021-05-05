//
//  CoordinatorOutput.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol CoordinatorOutput: Coordinator{
    
    var finishFlow: (() -> Void)? { get set }
}
