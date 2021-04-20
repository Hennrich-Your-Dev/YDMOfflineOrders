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
import YDUtilities

class OrdersCollectionViewCell: UICollectionViewCell {
  // Components
  let containerView = UIView()
  let storeNameLabel = UILabel()
  let addressLabel = UILabel()
  let dateLabel = UILabel()
  let topStackView = UIStackView()
  var topStackTrailingConstraint: NSLayoutConstraint!
  let productsCount = UILabel()
  let productsDetailsButton = UIButton()
  let stackView = UIStackView()
  let noteButton = UIButton()
  let priceLabel = UILabel()

  let shimmerContainerView = UIView()
  let shimmerStoreNameLabel = UIView()
  let shimmerAddressLabel = UIView()
  let shimmerDateLabel = UIView()
  let shimmerProductsCount = UIView()
  var shimmerMiddleView = UIView()
  var shimmerPhotoView = UIView()
  var shimmerProductNameView = UIView()
  var shimmerProductSubNameView = UIView()
  let shimmerPriceLabel = UIView()
  let shimmerNoteButton = UIButton()

  // Properties
  var currentOrder: YDOfflineOrdersOrder?
  var productCallback: ((YDOfflineOrdersProduct) -> Void)?
  var orderDetailsCallback: (() -> Void)?
  var noteCallback: (() -> Void)?
  lazy var shimmersViews: [UIView] = {
    [
      shimmerStoreNameLabel,
      shimmerAddressLabel,
      shimmerDateLabel,
      shimmerProductsCount,
      shimmerPhotoView,
      shimmerProductNameView,
      shimmerProductSubNameView,
      shimmerPriceLabel
    ]
  }()

  // Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    contentView.backgroundColor = UIColor.Zeplin.white
    contentView.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    contentView.layer.cornerRadius = 6

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
    changeUIState(with: .normal)

    super.prepareForReuse()
  }

  // Actions
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
    createContainerView()
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

    // Shimmer
    createShimmerContainerView()
    createShimmerStoreNameLabel()
    createShimmerAddressLabel()
    createShimmerDateLabel()
    createShimmerProductsCount()

    let shimmerSeparatorView = createShimmerSeparator(firstSeparator: true)
    createShimmerMiddleView(parent: shimmerSeparatorView)
    createShimmerProductCard()

    let shimmerSeparatorUnderStack = createShimmerSeparator(firstSeparator: false)
    createShimmerNoteButton(parent: shimmerSeparatorUnderStack)
    createShimmerPriceLabel(parent: shimmerSeparatorUnderStack)
  }

  func createContainerView() {
    contentView.addSubview(containerView)

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  func createStoreNameLabel() {
    storeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    storeNameLabel.textAlignment = .left
    storeNameLabel.textColor = UIColor.Zeplin.black
    storeNameLabel.numberOfLines = 1
    storeNameLabel.text = .loremIpsum(ofLength: 50)
    containerView.addSubview(storeNameLabel)

    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor.constraint(
        equalTo: containerView.topAnchor,
        constant: 16
      ),
      storeNameLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 16
      ),
      storeNameLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -16
      ),
      storeNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func createAddressLabel() {
    addressLabel.font = .systemFont(ofSize: 14)
    addressLabel.textAlignment = .left
    addressLabel.textColor = UIColor.Zeplin.grayLight
    addressLabel.numberOfLines = 1
    addressLabel.text = .loremIpsum(ofLength: 50)
    containerView.addSubview(addressLabel)

    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressLabel.topAnchor.constraint(
        equalTo: storeNameLabel.bottomAnchor,
        constant: 3
      ),
      addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
      addressLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -8
      ),
      addressLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createDateLabel() {
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = UIColor.Zeplin.grayLight
    containerView.addSubview(dateLabel)

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
    containerView.addSubview(topStackView)

    topStackView.translatesAutoresizingMaskIntoConstraints = false

    topStackTrailingConstraint = topStackView.trailingAnchor
      .constraint(equalTo: containerView.trailingAnchor, constant: -16)

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

    productsDetailsButton.addTarget(
      self,
      action: #selector(onOrderDetailsAction),
      for: .touchUpInside
    )
  }

  @objc func onOrderDetailsAction() {
    orderDetailsCallback?()
  }

  func createSeparator(firstSeparator: Bool) -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = firstSeparator ?
      UIColor.Zeplin.grayDisabled : UIColor.Zeplin.grayOpaque
    containerView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    if firstSeparator {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 13),
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
        separatorView.leadingAnchor.constraint(
          equalTo: containerView.leadingAnchor,
          constant: 16
        ),
        separatorView.trailingAnchor.constraint(
          equalTo: containerView.trailingAnchor,
          constant: -16
        )
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
    containerView.addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 12),
      stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func createNoteButton(parent: UIView) {
    noteButton.titleLabel?.font = .systemFont(ofSize: 14)
    noteButton.setTitleColor(UIColor.Zeplin.redBranding, for: .normal)
    noteButton.setTitle("ver nota fiscal", for: .normal)
    containerView.addSubview(noteButton)

    noteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      noteButton.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10),
      noteButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      noteButton.heightAnchor.constraint(equalToConstant: 35)
    ])
    noteButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    noteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    noteButton.addTarget(
      self,
      action: #selector(onNoteAction),
      for: .touchUpInside
    )
  }

  func createValueLabel(parent: UIView) {
    let valueTotalLabel = UILabel()
    valueTotalLabel.font = .systemFont(ofSize: 12)
    valueTotalLabel.textAlignment = .left
    valueTotalLabel.textColor = UIColor.Zeplin.grayLight
    valueTotalLabel.numberOfLines = 1
    valueTotalLabel.text = "total -"
    containerView.addSubview(valueTotalLabel)

    valueTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      valueTotalLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 17
      ),
      valueTotalLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      valueTotalLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    valueTotalLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .horizontal
    )
    valueTotalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    //
    priceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    priceLabel.textAlignment = .left
    priceLabel.textColor = UIColor.Zeplin.black
    containerView.addSubview(priceLabel)

    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 13
      ),
      priceLabel.leadingAnchor.constraint(
        equalTo: valueTotalLabel.trailingAnchor,
        constant: 3
      ),
      priceLabel.trailingAnchor.constraint(
        equalTo: noteButton.leadingAnchor,
        constant: -10
      ),
      priceLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: Shimmer
extension OrdersCollectionViewCell {
  func createShimmerContainerView() {
    contentView.addSubview(shimmerContainerView)
    shimmerContainerView.isHidden = true

    shimmerContainerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      shimmerContainerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor
      ),
      shimmerContainerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor
      ),
      shimmerContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  func createShimmerStoreNameLabel() {
    shimmerContainerView.addSubview(shimmerStoreNameLabel)
    shimmerStoreNameLabel.backgroundColor = .white
    shimmerStoreNameLabel.layer.cornerRadius = 6
    shimmerStoreNameLabel.clipsToBounds = true

    shimmerStoreNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerStoreNameLabel.topAnchor.constraint(
        equalTo: shimmerContainerView.topAnchor,
        constant: 16
      ),
      shimmerStoreNameLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      shimmerStoreNameLabel.trailingAnchor.constraint(
        equalTo: shimmerContainerView.trailingAnchor, constant: -54),
      shimmerStoreNameLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerAddressLabel() {
    shimmerContainerView.addSubview(shimmerAddressLabel)
    shimmerAddressLabel.backgroundColor = UIColor.Zeplin.grayLight
    shimmerAddressLabel.layer.cornerRadius = 6
    shimmerAddressLabel.clipsToBounds = true

    shimmerAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerAddressLabel.topAnchor.constraint(
        equalTo: shimmerStoreNameLabel.bottomAnchor,
        constant: 7
      ),
      shimmerAddressLabel.leadingAnchor.constraint(
        equalTo: shimmerStoreNameLabel.leadingAnchor
      ),
      shimmerAddressLabel.trailingAnchor.constraint(
        equalTo: shimmerContainerView.trailingAnchor,
        constant: -16
      ),
      shimmerAddressLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerDateLabel() {
    shimmerContainerView.addSubview(shimmerDateLabel)
    shimmerDateLabel.backgroundColor = UIColor.Zeplin.grayLight
    shimmerDateLabel.layer.cornerRadius = 6
    shimmerDateLabel.clipsToBounds = true

    shimmerDateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerDateLabel.topAnchor.constraint(
        equalTo: shimmerAddressLabel.bottomAnchor,
        constant: 21
      ),
      shimmerDateLabel.leadingAnchor.constraint(
        equalTo: shimmerAddressLabel.leadingAnchor
      ),
      shimmerDateLabel.heightAnchor.constraint(equalToConstant: 13),
      shimmerDateLabel.widthAnchor.constraint(equalToConstant: 137)
    ])
  }

  func createShimmerProductsCount() {
    shimmerContainerView.addSubview(shimmerProductsCount)
    shimmerProductsCount.backgroundColor = UIColor.Zeplin.grayLight
    shimmerProductsCount.layer.cornerRadius = 6
    shimmerProductsCount.clipsToBounds = true

    shimmerProductsCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductsCount.topAnchor.constraint(
        equalTo: shimmerAddressLabel.bottomAnchor,
        constant: 21
      ),
      shimmerProductsCount.leadingAnchor.constraint(
        equalTo: shimmerDateLabel.trailingAnchor,
        constant: 38
      ),
      shimmerProductsCount.trailingAnchor.constraint(
        equalTo: shimmerContainerView.trailingAnchor,
        constant: -16
      ),
      shimmerProductsCount.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerSeparator(firstSeparator: Bool) -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = firstSeparator ?
      UIColor.Zeplin.grayDisabled : UIColor.Zeplin.grayOpaque
    shimmerContainerView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    if firstSeparator {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(
          equalTo: shimmerDateLabel.bottomAnchor,
          constant: 13
        ),
        separatorView.leadingAnchor.constraint(
          equalTo: shimmerContainerView.leadingAnchor
        ),
        separatorView.trailingAnchor.constraint(
          equalTo: shimmerContainerView.trailingAnchor
        )
      ])
    } else {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(
          equalTo: shimmerMiddleView.bottomAnchor,
          constant: 12
        ),
        separatorView.leadingAnchor.constraint(
          equalTo: shimmerContainerView.leadingAnchor,
          constant: 16
        ),
        separatorView.trailingAnchor.constraint(
          equalTo: shimmerContainerView.trailingAnchor,
          constant: -16
        )
      ])
    }

    return separatorView
  }

  func createShimmerMiddleView(parent: UIView) {
    shimmerContainerView.addSubview(shimmerMiddleView)
    shimmerMiddleView.backgroundColor = UIColor.Zeplin.white

    shimmerMiddleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerMiddleView.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 12
      ),
      shimmerMiddleView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      shimmerMiddleView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      shimmerMiddleView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func createShimmerProductCard() {
    shimmerMiddleView.addSubview(shimmerPhotoView)
    shimmerPhotoView.backgroundColor = UIColor.Zeplin.white
    shimmerPhotoView.layer.cornerRadius = 8
    shimmerPhotoView.clipsToBounds = true

    shimmerPhotoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPhotoView.centerYAnchor.constraint(
        equalTo: shimmerMiddleView.centerYAnchor
      ),
      shimmerPhotoView.leadingAnchor.constraint(
        equalTo: shimmerMiddleView.leadingAnchor
      ),
      shimmerPhotoView.widthAnchor.constraint(equalToConstant: 45),
      shimmerPhotoView.heightAnchor.constraint(equalToConstant: 45)
    ])

    // Product name
    shimmerMiddleView.addSubview(shimmerProductNameView)
    shimmerProductNameView.backgroundColor = UIColor.Zeplin.white
    shimmerProductNameView.layer.cornerRadius = 6
    shimmerProductNameView.clipsToBounds = true

    shimmerProductNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductNameView.topAnchor.constraint(
        equalTo: shimmerMiddleView.topAnchor,
        constant: 8
      ),
      shimmerProductNameView.leadingAnchor.constraint(
        equalTo: shimmerPhotoView.trailingAnchor,
        constant: 10
      ),
      shimmerProductNameView.trailingAnchor.constraint(
        equalTo: shimmerMiddleView.trailingAnchor
      ),
      shimmerProductNameView.heightAnchor.constraint(equalToConstant: 13)
    ])

    // Product subname
    shimmerMiddleView.addSubview(shimmerProductSubNameView)
    shimmerProductSubNameView.backgroundColor = UIColor.Zeplin.white
    shimmerProductSubNameView.layer.cornerRadius = 6
    shimmerProductSubNameView.clipsToBounds = true

    shimmerProductSubNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerProductSubNameView.topAnchor.constraint(
        equalTo: shimmerProductNameView.bottomAnchor,
        constant: 7
      ),
      shimmerProductSubNameView.leadingAnchor.constraint(
        equalTo: shimmerProductNameView.leadingAnchor
      ),
      shimmerProductSubNameView.trailingAnchor.constraint(
        equalTo: shimmerProductNameView.centerXAnchor
      ),
      shimmerProductSubNameView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerNoteButton(parent: UIView) {
    shimmerContainerView.addSubview(shimmerNoteButton)
    shimmerNoteButton.titleLabel?.font = .systemFont(ofSize: 14)
    shimmerNoteButton.setTitleColor(
      UIColor.Zeplin.redBranding.withAlphaComponent(0.3),
      for: .normal
    )
    shimmerNoteButton.setTitle("ver nota fiscal", for: .normal)

    shimmerNoteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerNoteButton.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 10
      ),
      shimmerNoteButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
      shimmerNoteButton.heightAnchor.constraint(equalToConstant: 35)
    ])
  }

  func createShimmerPriceLabel(parent: UIView) {
    shimmerContainerView.addSubview(shimmerPriceLabel)
    shimmerPriceLabel.backgroundColor = UIColor.Zeplin.black
    shimmerPriceLabel.layer.cornerRadius = 6
    shimmerPriceLabel.clipsToBounds = true

    shimmerPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPriceLabel.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 22
      ),
      shimmerPriceLabel.leadingAnchor.constraint(
        equalTo: shimmerContainerView.leadingAnchor,
        constant: 16
      ),
      shimmerPriceLabel.trailingAnchor.constraint(
        equalTo: noteButton.leadingAnchor,
        constant: -50
      ),
      shimmerPriceLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }
}

// MARK: UIState Delegate
extension OrdersCollectionViewCell: UIStateDelegate {
  func changeUIState(with type: UIStateEnum) {
    switch type {
      case .normal:
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.containerView.isHidden = false
          self.shimmerContainerView.isHidden = true
          self.shimmersViews.forEach { $0.stopShimmer() }
        }

      case .loading:
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.containerView.isHidden = true
          self.shimmerContainerView.isHidden = false
          self.shimmersViews.forEach { $0.startShimmer() }
        }

      case .error:
        break
    }
  }
}
