//
//  BaseCoordinator.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

//Classe that represents a base coordinator
class BaseCoordinator: NSObject, Coordinator {
    
    
    var childCoordinators: [Coordinator] = []
    
    func start() {}
    
    /// Method to add child coordinators
    /// - Note It's necessary to keep a referece to child coordinators for them not be deallocated
    /// - Parameter coordinator: Coordinator
    func addChild(_ coordinator: Coordinator) {
      guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
      childCoordinators.append(coordinator)
    }
    
    /// Method to remoce child coordinators
    /// - Parameter coordinator: Coordinator?
    func removeChild(_ coordinator: Coordinator?) {
      
      guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
      
      if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
          coordinator.childCoordinators
              .filter({ $0 !== coordinator })
              .forEach({ coordinator.removeChild($0) })
      }
        
      for (index, element) in childCoordinators.enumerated() where element === coordinator {
          childCoordinators.remove(at: index)
          break
      }
    }
}
