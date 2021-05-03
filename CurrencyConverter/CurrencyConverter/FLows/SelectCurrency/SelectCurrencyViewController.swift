//
//  SelectCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import UIKit

class SelectCurrencyViewController: UIViewController {
    
    public enum CurrencySource {
        case from
        case to
    }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(SelectCurrencyTableViewCell.self, forCellReuseIdentifier: SelectCurrencyTableViewCell.reuserIdentifier)
        tv.isHidden = true
        return tv
    }()
    
    private let confirmButton: CCButton = {
        let button = CCButton(titleText: "Okay", background: .blue, borderColor: .blue)
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var didTapInConfirmButton: (() -> Void)?
    private let currencySource: CurrencySource
    
    weak var delegate: SelectCurrencyDelegate?
    
    let selectCurrencyViewModel = SelectCurrencyViewModel()
    
    var currencies: [Currency] = []
    
    private var selectedCurrency: Currency? {
        didSet {
            confirmButton.isUserInteractionEnabled = selectedCurrency != nil
        }
    }
    
    init(currencySource: CurrencySource) {
        self.currencySource = currencySource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        selectCurrencyViewModel.list()
    }
    
    @objc
    private func didTapConfirmButton() {
        delegate?.didSelect(currency: selectedCurrency!, source: currencySource)
        didTapInConfirmButton?()
    }
    
}


extension SelectCurrencyViewController: ViewCoding {
    func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        tableView
            .fillSuperviewWidth()
            .anchorVertical(top: view.topAnchor, bottom: confirmButton.topAnchor, bottomConstant: 20)
        
        confirmButton
            .anchorVertical(bottom: view.safeAreaLayoutGuide.bottomAnchor,bottomConstant: 10)
            .fillSuperviewWidth(left: 20, right: 20)
            .anchorSize(heightConstant: 50)
        
        activityIndicator.anchorCenterToSuperview()
    }
    
    func setupAdditionalConfiguration() {
        tableView.rowHeight = 50
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
            
        view.backgroundColor = .white
        
        selectCurrencyViewModel.bindListAvaiableCurrencies = { currencies in
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.confirmButton.isHidden = false
                self.activityIndicator.stopAnimating()
                self.currencies = currencies
                self.tableView.reloadData()
            }
        }
        
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
}

extension SelectCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyTableViewCell.reuserIdentifier) as? SelectCurrencyTableViewCell {
            cell.config(currency: currencies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrency = currencies[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedCurrency ==  currencies[indexPath.row] {
            selectedCurrency = nil
        }
    }
}
