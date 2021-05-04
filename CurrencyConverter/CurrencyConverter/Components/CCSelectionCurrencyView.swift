//
//  CCSelectionCurrencyButton.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import UIKit

class CCSelectionCurrencyView: UIView {

    //MARK: Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    public let button: CCButton = {
        let button = CCButton(titleText: "")
        button.tag = 0
        return button
    }()
    
    //MARK: prorperties
    private let title: String
    
    //MARK: -> init
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with currency: Currency?) {
        button.setTitle(currency?.currencyName, for: .normal)
    }
}

//MARK: View Coding
extension CCSelectionCurrencyView: ViewCoding {
    
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        titleLabel
            .anchorVertical(top: topAnchor)
            .anchorHorizontal(left: leftAnchor)
            .anchorSize(heightConstant: 22)
        
        button
            .anchorVertical(top: titleLabel.bottomAnchor, bottom: bottomAnchor, topConstant: 5)
            .anchorHorizontal(left: leftAnchor, right: rightAnchor)
        
        
    }
    
    func setupAdditionalConfiguration() {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
}

