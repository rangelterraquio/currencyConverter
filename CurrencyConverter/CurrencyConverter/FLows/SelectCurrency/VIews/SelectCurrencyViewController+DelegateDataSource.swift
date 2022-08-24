//
//  SelectCurrencyViewController+DelegateDataSource.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 03/05/21.
//

import Foundation
import UIKit

//MARK: - UITableViewDelegate + UITableViewDataSource
extension SelectCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCurrencyViewModel.getNumberOfCurrencies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyTableViewCell.reuserIdentifier) as? SelectCurrencyTableViewCell,
           let currency = selectCurrencyViewModel.getCurrency(at: indexPath.row) {
            cell.config(currency: currency)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCurrency = currencies[indexPath.row]
        selectCurrencyViewModel.didSelectCurrency(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectCurrencyViewModel.didDeselectCurrency(at: indexPath.row)
//        if selectedCurrency ==  currencies[indexPath.row] {
//            selectedCurrency = nil
//        }
    }
}
