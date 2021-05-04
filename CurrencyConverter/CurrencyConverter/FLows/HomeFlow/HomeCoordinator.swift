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
    
    private weak var homeHandler: SelectCurrencyDelegate?
    
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
        self.homeHandler = homeHandler
        homeHandler.didTapSelectionCurrencyButton = { source in
            self.showSelectionCurrencyView(source: source)
        }
        router.setRootModule(homeHandler, hideBar: true)
        homeHandler.navigationItem.backButtonTitle = ""
    }
    
    private func showSelectionCurrencyView(source: SelectCurrencyViewController.CurrencySource) {
        let vc = factory.makeSelectCurrencyHandler(selection: source)
        vc.delegate = homeHandler
        
        vc.didTapInConfirmButton =  {
            self.router.popModule(animated: true)
        }
        
        router.push(vc, animated: true, hideNavBar: false, completion: nil)
    }
    
}
