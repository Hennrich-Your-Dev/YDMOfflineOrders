//
//  OrdersCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 09/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets

class OrdersCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var addressLabel = UILabel()
  var subAddressLabel = UILabel()
  var dateLabel = UILabel()
  var productsCount = UILabel()
  var stackView = UIStackView()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 235)
    ])

    contentView.backgroundColor = UIColor.Zeplin.white
    contentView.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    contentView.layer.cornerRadius = 6
    contentView.layer.masksToBounds = false

    layer.masksToBounds = false
    
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func config() {}
}

// MARK: Layout
extension OrdersCollectionViewCell {
  func setUpLayout() {
    createAddressLabel()
    createSubAddressLabel()
    createDateLabel()

    _ = createSeparator()
  }

  func createAddressLabel() {
    addressLabel.font = .systemFont(ofSize: 16, weight: .bold)
    addressLabel.textAlignment = .left
    addressLabel.textColor = UIColor.Zeplin.black
    addressLabel.numberOfLines = 1
    addressLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(addressLabel)

    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      addressLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func createSubAddressLabel() {
    subAddressLabel.font = .systemFont(ofSize: 14)
    subAddressLabel.textAlignment = .left
    subAddressLabel.textColor = UIColor.Zeplin.grayLight
    subAddressLabel.numberOfLines = 1
    subAddressLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(subAddressLabel)

    subAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subAddressLabel.topAnchor.constraint(
        equalTo: addressLabel.bottomAnchor,
        constant: 3
      ),
      subAddressLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
      subAddressLabel.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -8
      ),
      subAddressLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createDateLabel() {
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = UIColor.Zeplin.grayLight
    dateLabel.numberOfLines = 1
    dateLabel.text = "18/04/2020 às 16:42h"
    contentView.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(
        equalTo: subAddressLabel.bottomAnchor,
        constant: 21
      ),
      dateLabel.leadingAnchor.constraint(equalTo: subAddressLabel.leadingAnchor),
      dateLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createSeparator() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.Zeplin.grayDisabled
    contentView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 13),
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])

    return separatorView
  }

//  func createValueTotalLabel() -> UILabel {
//    let valueTotalLabel = UILabel()
//    valueTotalLabel.font = .systemFont(ofSize: 12)
//    valueTotalLabel.textAlignment = .left
//    valueTotalLabel.textColor = UIColor.Zeplin.grayLight
//    valueTotalLabel.numberOfLines = 1
//    valueTotalLabel.text = "total:"
//    contentView.addSubview(valueTotalLabel)
//
//    valueTotalLabel.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      valueTotalLabel.topAnchor.constraint(equalTo:  self.productNameLabel.bottomAnchor,
//                                            constant: 7),
//      valueTotalLabel.leadingAnchor.constraint(equalTo: self.productNameLabel.leadingAnchor),
//      valueTotalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
//                                              constant: -8),
//      valueTotalLabel.heightAnchor.constraint(equalToConstant: 14)
//    ])
//
//    return valueTotalLabel
//  }
//
//  func createValueLabel(parent: UIView) {
//    self.productPriceLabel = UILabel()
//    productPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
//    productPriceLabel.textAlignment = .left
//    productPriceLabel.textColor = UIColor.Zeplin.black
//    productPriceLabel.numberOfLines = 1
//    productPriceLabel.text = "R$ 41,91"
//    contentView.addSubview(productPriceLabel)
//
//    let percent = contentView.frame.size.width * 0.27
//
//    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      productPriceLabel.topAnchor.constraint(equalTo:  parent.bottomAnchor,
//                                            constant: 1),
//      productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
//                                                constant: -16),
//      productPriceLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
//      productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
//                                                  constant: -percent),
//      productPriceLabel.heightAnchor.constraint(equalToConstant: 28)
//    ])
//
//    productPriceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//  }
}
