//
//  SelectCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import Foundation
import UIKit

final class SelectCurrencyViewController: UIViewController {
    
    //MARK: - Views
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(SelectCurrencyTableViewCell.self, forCellReuseIdentifier: SelectCurrencyTableViewCell.reuserIdentifier)
        tv.isHidden = true
        return tv
    }()
    
    private let confirmButton: CCButton = {
        let button = CCButton(titleText: "Okay", background: .blue, borderColor: .blue)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
          let imgFilter = UIImage(systemName: "slider.horizontal.3")?.withRenderingMode(.alwaysOriginal)
          let filterItem = UIBarButtonItem(image: imgFilter, style: .plain, target: self, action: #selector(didTapFilterButton))
        filterItem.isEnabled = true
          return filterItem
      }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .italicSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    //MARK: - Properties
    public var didTapInConfirmButton: (() -> Void)?
        
    weak var delegate: SelectCurrencyDelegate?
    
    var selectCurrencyViewModel: SelectCurrencyViewModelProtocol
    
    //MARK: - Init
    init(viewModel: SelectCurrencyViewModelProtocol) {
        self.selectCurrencyViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        navigationItem.titleView = searchBar
        selectCurrencyViewModel.list()
    }
    
    @objc
    private func didTapConfirmButton() {
        guard let selectedCurrency = selectCurrencyViewModel.getSelectedCurrency() else { return }
        
        let source = selectCurrencyViewModel.getCurrencySource()
        delegate?.didSelect(currency: selectedCurrency, source: source)
        
        didTapInConfirmButton?()
    }
    
    @objc
    private func didTapFilterButton() {
        showFilterActionSheet()
    }
    
    private func showFilterActionSheet() {
        let actionSheet: UIAlertController = UIAlertController(title: "Select a Filter", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        let byNameAction = UIAlertAction(title: "By Name", style: .default) { [weak self] _ in
            self?.selectCurrencyViewModel.filterList(by: .byName)
        }
        
        let byCodeAction = UIAlertAction(title: "By Code", style: .default) { [weak self] _ in
            self?.selectCurrencyViewModel.filterList(by: .byCode)
        }
        
        let noneAction = UIAlertAction(title: "None", style: .default) { [weak self] _ in
            self?.selectCurrencyViewModel.filterList(by: .none)
        }
        
        actionSheet.addAction(byCodeAction)
        actionSheet.addAction(byNameAction)
        actionSheet.addAction(noneAction)
        actionSheet.addAction(cancelActionButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - ViewCoding
extension SelectCurrencyViewController: ViewCoding {
    func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
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
        
        errorLabel
            .anchorCenterToSuperview()
            .anchorSizeWithMultiplier(width: view.widthAnchor, widthMultiplier: 0.85)
    }
    
    func setupAdditionalConfiguration() {
        tableView.rowHeight = 50
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
            
        view.backgroundColor = .white
        
        selectCurrencyViewModel.bindListAvaiableCurrencies = {
            DispatchQueue.main.async {
                self.errorLabel.isHidden = true
                self.tableView.isHidden = false
                self.confirmButton.isHidden = false
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
      
        selectCurrencyViewModel.bindLoadingState = {
            DispatchQueue.main.async {
                self.errorLabel.isHidden = true
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.confirmButton.isHidden = true
                self.tableView.isHidden = true
            }
        }
        
        selectCurrencyViewModel.bindErrorState = { error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.confirmButton.isHidden = true
                self.tableView.isHidden = true
                self.errorLabel.isHidden = false
                self.errorLabel.text = error
            }
        }
        
        selectCurrencyViewModel.bindConfirmButtonState = { isEnabled in
            DispatchQueue.main.async {
                self.confirmButton.isUserInteractionEnabled = isEnabled
            }
        }
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        navigationItem.setRightBarButton(filterButton, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SelectCurrencyViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.setRightBarButton(filterButton, animated: true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.setRightBarButton(filterButton, animated: true)
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selectCurrencyViewModel.search(for: searchBar.text)
    }
}
