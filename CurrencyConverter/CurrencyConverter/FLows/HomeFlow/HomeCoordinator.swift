//
//  HomeCoordinator.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

final class HomeCoordinator: BaseCoordinator {
  
    //MARK:  -> Propertis
  private let factory: HomeModuleFactory
  private let router: Router
  
    
  //MARK:  -> Initialize
  
  /// - Parameters:
  ///   - router: Router
  ///   - factory: HomeModuleFactory
  init(router: Router, factory: HomeModuleFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showHome()
  }
    
    /// Show home module
  private func showHome() {
    let homeHandler = factory.makeHomeHandler()
    router.setRootModule(homeHandler)
  }
  
}
