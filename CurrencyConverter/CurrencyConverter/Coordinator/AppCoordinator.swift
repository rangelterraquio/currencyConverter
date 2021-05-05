//
//  AppCoordinator.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

fileprivate enum InitializeInstructor{
    case home
}

final class AppCoordinator: BaseCoordinator{
    
    //MARK: -> Properties
    private let router: Router
    
    private let coordinatorFactory: CoordinatorFactory
 
    //MARK:  -> Initialize
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow(){
        let coordinator = coordinatorFactory.makeHomeCoordinator(router)
        addChild(coordinator)
        coordinator.start()
    }
}
