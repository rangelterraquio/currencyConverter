//
//  Commom.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation

protocol ViewCoding {
    
    func buildViewHierarchy()

    func setupConstraints()

    func setupAdditionalConfiguration()

    func setupView()
}


extension ViewCoding {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupAdditionalConfiguration() {}
}
