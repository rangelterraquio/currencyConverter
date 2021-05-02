//
//  RouterProtocol.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation

protocol RouterProtocol: Presentable {
  
  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)
  

  func push(_ module: Presentable?, animated: Bool)
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
  
  func popModule()
  func popModule(animated: Bool)
  
  func dismissModule()
  func dismissModule(animated: Bool, completion: (() -> Void)?)
  
  func setRootModule(_ module: Presentable?)
  
  func popToRootModule(animated: Bool)
}
