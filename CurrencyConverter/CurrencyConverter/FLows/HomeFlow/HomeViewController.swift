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
        vStack.spacing = 10
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
    
    private let fromCurrencyView: CCSelectionCurrencyView = {
        let view = CCSelectionCurrencyView(title: "From:")
        view.button.tag = 0
        return view
    }()
    
    private let toCurrencyView: CCSelectionCurrencyView = {
        let view = CCSelectionCurrencyView(title: "To:")
        view.button.tag = 1
        return view
    }()
    
    private let convertButton: CCButton = {
        let button = CCButton(titleText: "Convert", background: .blue, borderColor: .blue)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let resultLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var didTapSelectionCurrencyButton: ((SelectCurrencyViewController.CurrencySource) -> Void)?
    
    var convertViewModel = HomeConvertViewModel()
    
    private var fromCurrency: Currency? = Currency(code: "BRL", name: "Brazilian Real") {
        didSet {
            validateInputs()
        }
    }
    
    private var toCurrency: Currency? = Currency(code: "USD", name: "United States Dollar") {
        didSet {
            validateInputs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @objc
    func didTapSelectCurrencyButton(_ sender: UIButton) {
        sender.tag == 0 ? (didTapSelectionCurrencyButton?(.from)) : (didTapSelectionCurrencyButton?(.to))
    }
    
    @objc
    func didTapConvertButton() {
        if let from = fromCurrency, let to = toCurrency {
            resultLabel.text = ""
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let value = valueTextField.text ?? ""
            convertViewModel.convert(from: from, to: to, value: Float(value) ?? 0.0)
        }
    }
    
    private func validateInputs() {
        convertViewModel.validateInputs(from: fromCurrency, to: toCurrency, value: valueTextField.text)
    }
}


extension HomeViewController: ViewCoding {
  
    func buildViewHierarchy() {
        view.addSubview(vStack)
        view.addSubview(activityIndicator)
        
        vStack.addArrangedSubview(valueTextField)
        vStack.addArrangedSubview(fromCurrencyView)
        vStack.addArrangedSubview(toCurrencyView)
        vStack.addArrangedSubview(convertButton)
        vStack.addArrangedSubview(resultLabel)
    }
    
    func setupConstraints() {
        
        valueTextField
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        fromCurrencyView
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 90)
        
        toCurrencyView
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 90)
        
        convertButton
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        resultLabel
            
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 60)
        
        vStack
            .anchorCenterToSuperview()
            .anchorHorizontal(left: view.leftAnchor, right: view.rightAnchor, leftConstant: 20, rightConstant: 20)
        
        activityIndicator
            .anchorCenterY(to: resultLabel, constant: -15)
            .anchorCenterXToSuperview()
        
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        
        valueTextField.delegate = self
        
        fromCurrencyView.config(with: fromCurrency)
        fromCurrencyView.button.addTarget(self, action: #selector(didTapSelectCurrencyButton(_:)), for: .touchUpInside)
       
        toCurrencyView.config(with: toCurrency)
        toCurrencyView.button.addTarget(self, action: #selector(didTapSelectCurrencyButton(_:)), for: .touchUpInside)
        
        convertButton.addTarget(self, action: #selector(didTapConvertButton), for: .touchUpInside)
        
        convertViewModel.bindResultConversionModel = { [weak self] text in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.resultLabel.text = text
            }
        }
        
        convertViewModel.bindValidatedInputs = { [weak self] isValid in
            DispatchQueue.main.async {
                self?.convertButton.isUserInteractionEnabled = isValid
            }
        }
    }
}

extension HomeViewController: SelectCurrencyDelegate {
    
    func didSelect(currency: Currency, source: SelectCurrencyViewController.CurrencySource) {
        
        if source == .to {
            toCurrency = currency
            toCurrencyView.config(with: currency)
        } else {
            fromCurrency = currency
            fromCurrencyView.config(with: currency)
        }
    }
}


extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateInputs()
    }
}
