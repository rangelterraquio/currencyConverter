//
//  CoordinatorFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

/// Factory for coordinators
final class CoordinatorFactory{
    
    /// Method to create Home Coordinator
    /// - Parameter router: Router
    /// - Returns: HomeCoordinator
    func makeHomeCoordinator(_ router: Router) -> HomeCoordinator{
        return HomeCoordinator(router: router, factory: ModuleFactory())
    }
}
