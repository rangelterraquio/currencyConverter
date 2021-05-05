//
//  Presentable.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import Foundation
import UIKit

protocol Presentable {
  func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}
