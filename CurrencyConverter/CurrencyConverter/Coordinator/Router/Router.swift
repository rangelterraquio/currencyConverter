//
//  Router.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation
import UIKit
/// Class responsable for router mdules
class Router: NSObject, RouterProtocol{
    
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    

    //MARK: -> Initialize
    /// - Parameter rootController: UINavigationController
    init(rootController: UINavigationController) {
      self.rootController = rootController
      completions = [:]
    }
    
    func toPresent() -> UIViewController? {
      return rootController
    }
    
    func present(_ module: Presentable?) {
      present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
      guard let controller = module?.toPresent() else { return }
      rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
      dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
      rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
      push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard
          let controller = module?.toPresent(),
          (controller is UINavigationController == false)
          else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
          completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
      popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
      if let controller = rootController?.popViewController(animated: animated) {
        runCompletion(for: controller)
      }
    }
    
    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
    }
    
    func popToRootModule(animated: Bool) {
      if let controllers = rootController?.popToRootViewController(animated: animated) {
        controllers.forEach { controller in
          runCompletion(for: controller)
        }
      }
    }
    
    private func runCompletion(for controller: UIViewController) {
      guard let completion = completions[controller] else { return }
      completion()
      completions.removeValue(forKey: controller)
    }
}