//
//  CoordinatorFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

final class CoordinatorFactory {
    
    func makeHomeCoordinator(_ router: Router) -> HomeCoordinator {
        return HomeCoordinator(router: router, factory: ModuleFactory())
    }
}
