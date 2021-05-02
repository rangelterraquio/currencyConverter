//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import UIKit

class HomeViewController: UIViewController {

    private let vStack: UIStackView = {
       let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fill
        vStack.spacing = 5
        return vStack
    }()
    
    private let valueTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Type a value"
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.blue.cgColor
        tf.textColor = .black
        return tf
    }()
    private let fromCurrencyButton: UIButton = {
        let button = UIButton()
        button.setTitle("From", for: .normal)
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()
    
    private let toCurrencyButton: UIButton = {
        let button = UIButton()
        button.setTitle("To", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()
    
    private let convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let resultLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20)
        label.textColor = .blue
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        let service = CurrencyService()
//        service.list { (result) in
//            print(result)
//        }
    }


}


extension HomeViewController: ViewCoding {
  
    func buildViewHierarchy() {
        view.addSubview(vStack)
        
        vStack.addArrangedSubview(valueTextField)
        vStack.addArrangedSubview(fromCurrencyButton)
        vStack.addArrangedSubview(toCurrencyButton)
        vStack.addArrangedSubview(convertButton)
    }
    
    func setupConstraints() {
        
        valueTextField
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        fromCurrencyButton
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        toCurrencyButton
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        convertButton
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        
        vStack
            .anchorCenterToSuperview()
            .anchorHorizontal(left: view.leftAnchor, right: view.rightAnchor, leftConstant: 20, rightConstant: 20)
        
        
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
}
