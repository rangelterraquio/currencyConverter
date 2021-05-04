//
//  CCButton.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import UIKit

class CCButton: UIButton {
    private let colorBkg: UIColor
    private let colorBorder: UIColor
    //MARK: Initializers
    init(titleText: String, background color: UIColor = .white, borderColor: UIColor = .blue){
        colorBkg = color
        colorBorder = borderColor
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
            
        layer.borderWidth = 2
        setTitleColor(.black, for: .normal)
        layer.borderColor = UIColor.blue.cgColor
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if !isUserInteractionEnabled {
                backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
                layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            } else {
                backgroundColor = colorBkg
                layer.borderColor = colorBorder.cgColor
            }
        }
    }
}
