//
//  OrdersCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 09/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels

class OrdersCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var storeNameLabel = UILabel()
  var addressLabel = UILabel()
  var dateLabel = UILabel()
  var topStackView = UIStackView()
  var topStackTrailingConstraint: NSLayoutConstraint!
  var productsCount = UILabel()
  var productsDetailsButton = UIButton()
  var stackView = UIStackView()
  var noteButton = UIButton()
  var priceLabel = UILabel()

  var currentOrder: YDOfflineOrdersOrder?
  var productCallback: ((YDOfflineOrdersProduct) -> Void)?
  var orderDetailsCallback: (() -> Void)?
  var noteCallback: (() -> Void)?

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
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

  override func prepareForReuse() {
    if topStackView.subviews.count > 1 {
      topStackView.arrangedSubviews.last?.removeFromSuperview()
    }

    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    if topStackTrailingConstraint != nil {
      topStackTrailingConstraint.constant = -16
    }

    storeNameLabel.text = nil
    addressLabel.text = nil
    dateLabel.text = nil
    productsCount.text = nil
    priceLabel.text = nil
    productCallback = nil
    currentOrder = nil
    noteCallback = nil

    super.prepareForReuse()
  }

  // MARK: Actions
  func config(with order: YDOfflineOrdersOrder) {
    currentOrder = order
    storeNameLabel.text = order.storeName
    addressLabel.text = order.formatedAddress
    dateLabel.text = order.formatedDate
    priceLabel.text = order.formatedPrice

    if let products = order.products {
      productsCount.text = "total de produtos: \(products.count)"

      if products.count > 3 {
        createProductsDetailsButton()
      }

      for (index, product) in products.prefix(3).enumerated() {
        let productView = ProductCardInfoView()
        productView.phantomButton.tag = index
        productView.phantomButton.addTarget(
          self,
          action: #selector(onProductTap),
          for: .touchUpInside
        )
        productView.config(with: product)
        stackView.addArrangedSubview(productView)
      }
    }
  }

  @objc func onProductTap(_ sender: UIButton) {
    let index = sender.tag
    guard let product = currentOrder?.products?.at(index)
    else {
      return
    }

    productCallback?(product)
  }

  @objc func onNoteAction(_ sender: UIButton) {
    noteCallback?()
  }
}

// MARK: Layout
extension OrdersCollectionViewCell {
  func setUpLayout() {
    createStoreNameLabel()
    createAddressLabel()
    createDateLabel()
    createTopStackView()
    createProductsCount()

    let separatorView = createSeparator(firstSeparator: true)
    createStackView(parent: separatorView)

    let separatorUnderStack = createSeparator(firstSeparator: false)
    createNoteButton(parent: separatorUnderStack)
    createValueLabel(parent: separatorUnderStack)
  }

  func createStoreNameLabel() {
    storeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    storeNameLabel.textAlignment = .left
    storeNameLabel.textColor = UIColor.Zeplin.black
    storeNameLabel.numberOfLines = 1
    storeNameLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(storeNameLabel)

    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      storeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      storeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      storeNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func createAddressLabel() {
    addressLabel.font = .systemFont(ofSize: 14)
    addressLabel.textAlignment = .left
    addressLabel.textColor = UIColor.Zeplin.grayLight
    addressLabel.numberOfLines = 1
    addressLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(addressLabel)

    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressLabel.topAnchor.constraint(
        equalTo: storeNameLabel.bottomAnchor,
        constant: 3
      ),
      addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
      addressLabel.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -8
      ),
      addressLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createDateLabel() {
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = UIColor.Zeplin.grayLight
    contentView.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(
        equalTo: addressLabel.bottomAnchor,
        constant: 21
      ),
      dateLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
      dateLabel.heightAnchor.constraint(equalToConstant: 16),
      dateLabel.widthAnchor.constraint(equalToConstant: 137)
    ])
    dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  func createTopStackView() {
    topStackView.axis = .horizontal
    topStackView.alignment = .trailing
    topStackView.spacing = 2
    topStackView.distribution = .fillProportionally
    contentView.addSubview(topStackView)

    topStackView.translatesAutoresizingMaskIntoConstraints = false

    topStackTrailingConstraint = topStackView.trailingAnchor
      .constraint(equalTo: contentView.trailingAnchor, constant: -16)

    topStackTrailingConstraint.isActive = true

    NSLayoutConstraint.activate([
      topStackView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 11),
      topStackView.leadingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 12),
      topStackView.heightAnchor.constraint(equalToConstant: 35)
    ])
    topStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }

  func createProductsCount() {
    productsCount.font = .systemFont(ofSize: 13)
    productsCount.textAlignment = .right
    productsCount.textColor = UIColor.Zeplin.black
    productsCount.text = "total de produtos: 6"
    topStackView.addArrangedSubview(productsCount)

    productsCount.translatesAutoresizingMaskIntoConstraints = false
    productsCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }

  func createProductsDetailsButton() {
    productsDetailsButton.setImage(Icons.chevronRight, for: .normal)
    productsDetailsButton.tintColor = UIColor.Zeplin.black
    topStackView.addArrangedSubview(productsDetailsButton)

    topStackTrailingConstraint.constant = 0

    productsDetailsButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productsDetailsButton.heightAnchor.constraint(equalToConstant: 35),
      productsDetailsButton.widthAnchor.constraint(equalToConstant: 35)
    ])

    productsDetailsButton.addTarget(self, action: #selector(onOrderDetailsAction), for: .touchUpInside)
  }

  @objc func onOrderDetailsAction() {
    orderDetailsCallback?()
  }

  func createSeparator(firstSeparator: Bool) -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = firstSeparator ?
      UIColor.Zeplin.grayDisabled : UIColor.Zeplin.grayOpaque
    contentView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    if firstSeparator {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 13),
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
      ])
    }

    return separatorView
  }

  func createStackView(parent: UIView) {
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.distribution = .fillEqually
    stackView.spacing = -25
    stackView.layer.masksToBounds = false
    stackView.isUserInteractionEnabled = true
    contentView.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 12),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func createNoteButton(parent: UIView) {
    noteButton.titleLabel?.font = .systemFont(ofSize: 14)
    noteButton.setTitleColor(UIColor.Zeplin.redBranding, for: .normal)
    noteButton.setTitle("ver nota fiscal", for: .normal)
    contentView.addSubview(noteButton)

    noteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      noteButton.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10),
      noteButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      noteButton.heightAnchor.constraint(equalToConstant: 35)
    ])
    noteButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    noteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    noteButton.addTarget(self, action: #selector(onNoteAction), for: .touchUpInside)
  }

  func createValueLabel(parent: UIView) {
    let valueTotalLabel = UILabel()
    valueTotalLabel.font = .systemFont(ofSize: 12)
    valueTotalLabel.textAlignment = .left
    valueTotalLabel.textColor = UIColor.Zeplin.grayLight
    valueTotalLabel.numberOfLines = 1
    valueTotalLabel.text = "total -"
    contentView.addSubview(valueTotalLabel)

    valueTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      valueTotalLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 17
      ),
      valueTotalLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      valueTotalLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    valueTotalLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    valueTotalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    //
    priceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    priceLabel.textAlignment = .left
    priceLabel.textColor = UIColor.Zeplin.black
    priceLabel.numberOfLines = 1
    priceLabel.text = "R$ 41,91"
    contentView.addSubview(priceLabel)

    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 13
      ),
      priceLabel.leadingAnchor.constraint(equalTo: valueTotalLabel.trailingAnchor, constant: 3),
      priceLabel.trailingAnchor.constraint(
        equalTo: noteButton.leadingAnchor,
        constant: -10
      ),
      priceLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}
