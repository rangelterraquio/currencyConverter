//
//  ConnectivityMock.swift
//  CurrencyConverterTests
//
//  Created by Rangel Cardoso Dias on 24/08/22.
//

import Foundation
@testable import CurrencyConverter

final class ConnectivityMock: ConnectivityProtocol {
    var isConnected: Bool {
        return true
    }
    
    private var _isConnected: Bool
    
    init(isConnected: Bool = true) {
        self._isConnected = isConnected
    }
    
    func startMonitoring() {
        
    }
    
    func stopMonitoring() {
        
    }
}
