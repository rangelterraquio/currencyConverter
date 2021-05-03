//
//  CCButton.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import UIKit

class CCButton: UIButton {
    
    //MARK: Initializers
    init(titleText: String, background color: UIColor = .white, borderColor: UIColor = .blue){
        super.init(frame: .zero)
        
        setTitle(titleText, for: .normal)
        backgroundColor = color
        layer.borderColor = borderColor.cgColor

        setupAdditionalConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Method for setup additional configuration
    private func setupAdditionalConfiguration() {
        titleLabel?.font = .systemFont(ofSize: 20)
        setTitleColor(.blue, for: .normal)
            
        layer.borderWidth = 1
        setTitleColor(.black, for: .normal)
        layer.borderColor = UIColor.blue.cgColor
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if !isUserInteractionEnabled {
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
            }
        }
    }
    
}
