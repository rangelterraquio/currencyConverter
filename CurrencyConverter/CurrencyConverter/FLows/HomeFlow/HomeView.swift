//
//  HomeView.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import UIKit

protocol HomeViewActions: AnyObject {
    func didTapSelectCurrencyButton(source: CurrencySource)
    func didTapConvertButton(with text: String?)
    func didChangeValueText(_ text: String?)
    func didEndEditingValue(_ text: String?)
}

struct HomeViewState {
    let isLoading: Bool
    let isConvertEnabled: Bool
    let resultText: String?
    let errorText: String?
    let fromCurrency: Currency?
    let toCurrency: Currency?
    
    static let initial = HomeViewState(
        isLoading: false,
        isConvertEnabled: false,
        resultText: nil,
        errorText: nil,
        fromCurrency: nil,
        toCurrency: nil
    )
}

final class HomeView: UIView {
    
    weak var actionsDelegate: HomeViewActions?
    private var currentState: HomeViewState = .initial
    
    private enum UIConstants {
        static let horizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 10
        static let inputHeight: CGFloat = 60
        static let currencyViewHeight: CGFloat = 90
        static let buttonHeight: CGFloat = 60
        static let labelHeight: CGFloat = 60
        static let borderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 8
    }
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIConstants.verticalSpacing
        return stackView
    }()
    
    private lazy var valueTextField: CCTextField = {
        let textField = CCTextField()
        textField.placeholder = HomeConstants.Input.placeholder
        textField.layer.borderWidth = UIConstants.borderWidth
        textField.layer.cornerRadius = UIConstants.cornerRadius
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var fromCurrencyView: CCSelectionCurrencyView = {
        let view = CCSelectionCurrencyView(title: "From:")
        view.button.tag = CurrencySourceTag.from.rawValue
        view.button.addTarget(self, action: #selector(didTapSelectCurrencyButton(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var toCurrencyView: CCSelectionCurrencyView = {
        let view = CCSelectionCurrencyView(title: "To:")
        view.button.tag = CurrencySourceTag.to.rawValue
        view.button.addTarget(self, action: #selector(didTapSelectCurrencyButton(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var convertButton: CCButton = {
        let button = CCButton(titleText: "Convert", background: .blue, borderColor: .blue)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapConvertButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .italicSystemFont(ofSize: 18)
        label.textColor = .red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .blue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private enum CurrencySourceTag: Int {
        case from = 0
        case to = 1
        
        var currencySource: CurrencySource {
            switch self {
            case .from: return .from
            case .to: return .to
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with state: HomeViewState) {
        updateState(state)
    }
    
    func updateCurrencyViews(from: Currency?, to: Currency?) {
        fromCurrencyView.config(with: from)
        toCurrencyView.config(with: to)
    }
    
    var currentInputText: String? {
        return valueTextField.text
    }
    
    private func updateState(_ newState: HomeViewState) {
        let oldState = currentState
        currentState = newState
        
        // Update UI based on state changes
        if oldState.isLoading != newState.isLoading {
            updateLoadingState(newState.isLoading)
        }
        
        if oldState.isConvertEnabled != newState.isConvertEnabled {
            convertButton.isUserInteractionEnabled = newState.isConvertEnabled
        }
        
        if oldState.resultText != newState.resultText {
            resultLabel.text = newState.resultText
        }
        
        if oldState.errorText != newState.errorText {
            updateErrorState(newState.errorText)
        }
        
        if oldState.fromCurrency != newState.fromCurrency {
            fromCurrencyView.config(with: newState.fromCurrency)
        }
        
        if oldState.toCurrency != newState.toCurrency {
            toCurrencyView.config(with: newState.toCurrency)
        }
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            resultLabel.text = ""
            errorLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func updateErrorState(_ errorText: String?) {
        if let errorText = errorText {
            errorLabel.text = errorText
            errorLabel.isHidden = false
            resultLabel.text = ""
        } else {
            errorLabel.isHidden = true
        }
    }
    
    @objc private func didTapSelectCurrencyButton(_ sender: UIButton) {
        guard let tag = CurrencySourceTag(rawValue: sender.tag) else { return }
        actionsDelegate?.didTapSelectCurrencyButton(source: tag.currencySource)
    }
    
    @objc private func didTapConvertButton() {
        actionsDelegate?.didTapConvertButton(with: valueTextField.text)
    }
    
    @objc private func textFieldDidChange() {
        actionsDelegate?.didChangeValueText(valueTextField.text)
    }
}

extension HomeView: ViewCoding {
    
    func buildViewHierarchy() {
        addSubview(mainStackView)
        addSubview(activityIndicator)
        addSubview(errorLabel)
        
        mainStackView.addArrangedSubview(valueTextField)
        mainStackView.addArrangedSubview(fromCurrencyView)
        mainStackView.addArrangedSubview(toCurrencyView)
        mainStackView.addArrangedSubview(convertButton)
        mainStackView.addArrangedSubview(resultLabel)
    }
    
    func setupConstraints() {
        valueTextField
            .fillSuperviewWidth(left: UIConstants.horizontalPadding, right: UIConstants.horizontalPadding)
            .anchorSize(heightConstant: UIConstants.inputHeight)
        
        fromCurrencyView
            .fillSuperviewWidth(left: UIConstants.horizontalPadding, right: UIConstants.horizontalPadding)
            .anchorSize(heightConstant: UIConstants.currencyViewHeight)
        
        toCurrencyView
            .fillSuperviewWidth(left: UIConstants.horizontalPadding, right: UIConstants.horizontalPadding)
            .anchorSize(heightConstant: UIConstants.currencyViewHeight)
        
        convertButton
            .fillSuperviewWidth(left: UIConstants.horizontalPadding, right: UIConstants.horizontalPadding)
            .anchorSize(heightConstant: UIConstants.buttonHeight)
        
        resultLabel
            .fillSuperviewWidth(left: UIConstants.horizontalPadding, right: UIConstants.horizontalPadding)
            .anchorSize(heightConstant: UIConstants.labelHeight)
        
        mainStackView
            .anchorCenterToSuperview()
            .anchorHorizontal(left: leftAnchor, right: rightAnchor, leftConstant: UIConstants.horizontalPadding, rightConstant: UIConstants.horizontalPadding)
        
        activityIndicator
            .anchorVertical(top: convertButton.bottomAnchor, topConstant: UIConstants.horizontalPadding)
            .anchorCenterXToSuperview()
        
        errorLabel
            .anchorSizeWithMultiplier(width: widthAnchor, widthMultiplier: 0.85)
            .anchorCenterX(to: activityIndicator)
            .anchorVertical(top: convertButton.bottomAnchor, topConstant: UIConstants.horizontalPadding)
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
        
        // Setup gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionsDelegate?.didEndEditingValue(textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: HomeConstants.Input.allowedCharacters)
        let characterSet = CharacterSet(charactersIn: string)
        
        // Check if it's a valid character
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        // Prevent multiple decimal points
        if string == "." && textField.text?.contains(".") == true {
            return false
        }
        
        // Check for maximum value
        if let currentText = textField.text,
           let newText = (currentText as NSString?)?.replacingCharacters(in: range, with: string),
           let value = Float(newText),
           value > HomeConstants.Validation.maximumValue {
            return false
        }
        
        return true
    }
} 
