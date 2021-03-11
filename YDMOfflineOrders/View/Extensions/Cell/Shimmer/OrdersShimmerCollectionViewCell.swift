//
//  OrdersShimmerCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 11/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels

class OrdersShimmerCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var storeNameView = UIView()
  var addressView = UIView()
  var dateView = UIView()
  var topView = UIView()
  var middleView = UIView()
  var photoView = UIView()
  var productNameView = UIView()
  var productSubNameView = UIView()
  var noteButton = UIButton()
  var priceView = UIView()

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
    storeNameView.layer.removeAllAnimations()
    addressView.layer.removeAllAnimations()
    dateView.layer.removeAllAnimations()
    topView.layer.removeAllAnimations()
    priceView.layer.removeAllAnimations()
    photoView.layer.removeAllAnimations()
    productNameView.layer.removeAllAnimations()
    productSubNameView.layer.removeAllAnimations()

    super.prepareForReuse()
  }

  // MARK: Actions
  func startShimmerForCell() {
    DispatchQueue.main.async { [weak self] in
      self?.storeNameView.startShimmer()
      self?.addressView.startShimmer()
      self?.dateView.startShimmer()
      self?.topView.startShimmer()
      self?.photoView.startShimmer()
      self?.productNameView.startShimmer()
      self?.productSubNameView.startShimmer()
      self?.priceView.startShimmer()
    }
  }
}

// MARK: Layout
extension OrdersShimmerCollectionViewCell {
  func setUpLayout() {
    createStoreNameView()
    createAddressView()
    createDateView()

    let separatorView = createSeparator(firstSeparator: true)
    createMiddleView(parent: separatorView)
    createProductCard()

    let separatorUnderStack = createSeparator(firstSeparator: false)
    createNoteButton(parent: separatorUnderStack)
    createValueLabel(parent: separatorUnderStack)
  }

  func createStoreNameView() {
    storeNameView.backgroundColor = UIColor.Zeplin.black
    storeNameView.layer.cornerRadius = 3
    contentView.addSubview(storeNameView)

    storeNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      storeNameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      storeNameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      storeNameView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createAddressView() {
    addressView.backgroundColor = UIColor.Zeplin.grayLight
    addressView.layer.cornerRadius = 3
    contentView.addSubview(addressView)

    addressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressView.topAnchor.constraint(
        equalTo: storeNameView.bottomAnchor,
        constant: 3
      ),
      addressView.leadingAnchor.constraint(equalTo: storeNameView.leadingAnchor),
      addressView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -8
      ),
      addressView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createDateView() {
    dateView.backgroundColor = UIColor.Zeplin.grayLight
    dateView.layer.cornerRadius = 3
    contentView.addSubview(dateView)

    dateView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateView.topAnchor.constraint(
        equalTo: addressView.bottomAnchor,
        constant: 21
      ),
      dateView.leadingAnchor.constraint(equalTo: addressView.leadingAnchor),
      dateView.heightAnchor.constraint(equalToConstant: 13),
      dateView.widthAnchor.constraint(equalToConstant: 137)
    ])
    dateView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    dateView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  func createView() {
    topView.backgroundColor = UIColor.Zeplin.white
    contentView.addSubview(topView)

    topView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 23),
      topView.leadingAnchor.constraint(
        greaterThanOrEqualTo: dateView.trailingAnchor,
        constant: 38
      ),
      topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      topView.heightAnchor.constraint(equalToConstant: 13)
    ])
    topView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
        separatorView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 13),
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        separatorView.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 12),
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
      ])
    }

    return separatorView
  }

  func createMiddleView(parent: UIView) {
    middleView.backgroundColor = UIColor.Zeplin.white
    middleView.layer.masksToBounds = false
    contentView.addSubview(middleView)

    middleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      middleView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 12),
      middleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      middleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      middleView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func createProductCard() {
    photoView.backgroundColor = UIColor.Zeplin.white
    photoView.layer.cornerRadius = 8
    middleView.addSubview(photoView)

    photoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
      photoView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
      photoView.widthAnchor.constraint(equalToConstant: 45),
      photoView.heightAnchor.constraint(equalToConstant: 45)
    ])

    productNameView.backgroundColor = UIColor.Zeplin.white
    productNameView.layer.cornerRadius = 3
    middleView.addSubview(productNameView)

    productNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameView.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 5),
      productNameView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 10),
      productNameView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
      productNameView.heightAnchor.constraint(equalToConstant: 13)
    ])

    productSubNameView.backgroundColor = UIColor.Zeplin.white
    productSubNameView.layer.cornerRadius = 3
    middleView.addSubview(productSubNameView)

    productSubNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productSubNameView.topAnchor.constraint(equalTo: productNameView.bottomAnchor, constant: 7),
      productSubNameView.leadingAnchor.constraint(equalTo: productNameView.leadingAnchor),
      productSubNameView.trailingAnchor.constraint(equalTo: productNameView.centerXAnchor),
      productSubNameView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createNoteButton(parent: UIView) {
    noteButton.titleLabel?.font = .systemFont(ofSize: 14)
    noteButton.setTitleColor(UIColor.Zeplin.redBranding.withAlphaComponent(0.3), for: .normal)
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
  }

  func createValueLabel(parent: UIView) {
    priceView.backgroundColor = UIColor.Zeplin.black
    priceView.layer.cornerRadius = 3
    contentView.addSubview(priceView)

    priceView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceView.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 13
      ),
      priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
      priceView.trailingAnchor.constraint(
        equalTo: noteButton.leadingAnchor,
        constant: -10
      ),
      priceView.heightAnchor.constraint(equalToConstant: 13)
    ])
    priceView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}
