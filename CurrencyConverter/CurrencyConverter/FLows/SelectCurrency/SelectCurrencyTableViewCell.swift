//
//  SelectCurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 02/05/21.
//

import UIKit

class SelectCurrencyTableViewCell: UITableViewCell {
    
    static var reuserIdentifier: String {
        return String(describing: SelectCurrencyTableViewCell.self)
    }
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let selectedMarkImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: "checkmark")
        img.isHidden = true
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            print("Entrouu aqui")
            DispatchQueue.main.async { [self] in
                selectedMarkImage.isHidden = !isSelected
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedMarkImage.isHidden = true
    }
    
    func config(currency model: Currency) {
        guard let code = model.currencyCode, let name = model.currencyName else { return }
        currencyLabel.text = "\(code) : \(name)"
    }
}


extension SelectCurrencyTableViewCell: ViewCoding {
   
    func buildViewHierarchy() {
        contentView.addSubview(currencyLabel)
        contentView.addSubview(selectedMarkImage)
    }
    
    func setupConstraints() {
        currencyLabel
            .anchorHorizontal(left: contentView.leftAnchor, leftConstant: 10)
            .anchorCenterYToSuperview()
            .anchorSizeWithMultiplier(width: contentView.widthAnchor, widthMultiplier: 0.85)
            .anchorSize(heightConstant: 30)
        
        selectedMarkImage
            .anchorHorizontal(right: contentView.rightAnchor, rightConstant: 10)
            .anchorCenterYToSuperview()
            .anchorSize(widthConstant: 25, heightConstant: 25)
        
    }
}
