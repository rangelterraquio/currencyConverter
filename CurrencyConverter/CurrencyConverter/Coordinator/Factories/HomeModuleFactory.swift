//
//  HomeModuleFactory.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol HomeModuleFactory {
    /// Method to create LoginView
    /// - Returns: UIViewController
    func makeHomeHandler() -> HomeViewController
}
