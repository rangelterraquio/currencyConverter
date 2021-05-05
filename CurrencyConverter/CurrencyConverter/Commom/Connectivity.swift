//
//  Connectivity.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation
import Network

class Connectivity {
    
    static let shared = Connectivity()
 
    private init() {}
    
    deinit {
        stopMonitoring()
    }
    
    private var monitor: NWPathMonitor?
    
    public var isMonitoring = false

    public private(set) var isConnected: Bool = false
    
    func startMonitoring() {
        guard !isMonitoring else { return }
     
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
     
        monitor?.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
     
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
}
