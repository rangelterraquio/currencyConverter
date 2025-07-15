//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 01/05/21.
//

import UIKit

final class HomeViewController: UIViewController {

    public var didTapSelectionCurrencyButton: ((CurrencySource) -> Void)?
    
    private let convertViewModel: HomeConvertViewModelProtocol
    private var homeView: HomeView!
    private var viewConfigurator: HomeViewConfigurator!
    
    init(viewModel: HomeConvertViewModelProtocol = HomeConvertViewModel()) {
        self.convertViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        homeView = HomeView()
        homeView.actionsDelegate = self
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViewController() {
        viewConfigurator = HomeViewConfigurator(viewModel: convertViewModel, homeView: homeView)
    }
    
    private func convertCurrency(with text: String?) {
        guard let text = text, 
              let value = Float(text),
              value >= HomeConstants.Validation.minimumValue,
              value <= HomeConstants.Validation.maximumValue else {
            showInputError()
            return
        }
        
        viewConfigurator.startConversion()
        convertViewModel.convert(value: value)
    }
    
    private func showInputError() {
        let errorState = HomeViewState(
            isLoading: false,
            isConvertEnabled: false,
            resultText: nil,
            errorText: HomeConstants.ErrorMessages.invalidInput,
            fromCurrency: convertViewModel.getFromCurrency(),
            toCurrency: convertViewModel.getToCurrency()
        )
        
        homeView.configure(with: errorState)
    }
}

// MARK: - HomeViewActions
extension HomeViewController: HomeViewActions {
    
    func didTapSelectCurrencyButton(source: CurrencySource) {
        didTapSelectionCurrencyButton?(source)
    }
    
    func didTapConvertButton(with text: String?) {
        convertCurrency(with: text)
    }
    
    func didChangeValueText(_ text: String?) {
        convertViewModel.validateValueInput(value: text)
    }
    
    func didEndEditingValue(_ text: String?) {
        convertViewModel.validateValueInput(value: text)
    }
}

// MARK: - SelectCurrencyDelegate
extension HomeViewController: SelectCurrencyDelegate {
    
    func didSelect(currency: Currency, source: CurrencySource) {
        switch source {
        case .to:
            convertViewModel.setToCurrency(currency)
        case .from:
            convertViewModel.setFromCurrency(currency)
        }
        
        viewConfigurator.updateCurrencies(
            from: convertViewModel.getFromCurrency(),
            to: convertViewModel.getToCurrency()
        )
        
        // Validate inputs after currency selection
        viewConfigurator.validateInputs()
    }
}
