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
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()

  let containerView = UIView()
  var storeNameView = UIView()
  var addressView = UIView()
  var dateView = UIView()
  var topView = UIView()
  var middleView = UIView()
  var photoView = UIView()
  var productNameView = UIView()
  var productSubNameView = UIView()
  // var noteButton = UIButton()
  var priceView = UIView()

  lazy var shimmersViews: [UIView] = {
    [
      storeNameView,
      addressView,
      dateView,
      topView,
      photoView,
      productNameView,
      productSubNameView,
      priceView
    ]
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    shimmersViews.forEach { $0.stopShimmer() }

    super.prepareForReuse()
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.layer.shadowPath = UIBezierPath(
      roundedRect: containerView.bounds,
      cornerRadius: 6
    ).cgPath
  }

  // MARK: Actions
  func startShimmerForCell() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.shimmersViews.forEach { $0.startShimmer() }
    }
  }
}

// MARK: Layout
extension OrdersShimmerCollectionViewCell {
  func setUpLayout() {
    configureContainerView()
    createStoreNameView()
    createAddressView()
    createDateView()
    createView()

    let separatorView = createSeparator(firstSeparator: true)
    createMiddleView(parent: separatorView)
    createProductCard()

    let separatorUnderStack = createSeparator(firstSeparator: false)
    // createNoteButton(parent: separatorUnderStack)
    createValueLabel(parent: separatorUnderStack)
  }

  func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = UIColor.Zeplin.white
    containerView.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    containerView.layer.cornerRadius = 6

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor
        .constraint(equalTo: contentView.topAnchor, constant: 1),
      containerView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 24),
      containerView.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -24),
      containerView.bottomAnchor
        .constraint(equalTo: contentView.bottomAnchor, constant: -1)
    ])
  }

  func createStoreNameView() {
    storeNameView.backgroundColor = UIColor.Zeplin.black
    storeNameView.layer.cornerRadius = 6
    storeNameView.clipsToBounds = true
    containerView.addSubview(storeNameView)

    storeNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      storeNameView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      storeNameView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -54),
      storeNameView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createAddressView() {
    addressView.backgroundColor = UIColor.Zeplin.grayLight
    addressView.layer.cornerRadius = 6
    addressView.clipsToBounds = true
    containerView.addSubview(addressView)

    addressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      addressView.topAnchor.constraint(
        equalTo: storeNameView.bottomAnchor,
        constant: 7
      ),
      addressView.leadingAnchor.constraint(equalTo: storeNameView.leadingAnchor),
      addressView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -16
      ),
      addressView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createDateView() {
    dateView.backgroundColor = UIColor.Zeplin.grayLight
    dateView.layer.cornerRadius = 6
    dateView.clipsToBounds = true
    containerView.addSubview(dateView)

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
  }

  func createView() {
    topView.backgroundColor = UIColor.Zeplin.grayLight
    topView.layer.cornerRadius = 6
    topView.clipsToBounds = true
    containerView.addSubview(topView)

    topView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 21),
      topView.leadingAnchor.constraint(
        equalTo: dateView.trailingAnchor,
        constant: 38
      ),
      topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      topView.heightAnchor.constraint(equalToConstant: 13)
    ])
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
        separatorView.topAnchor
          .constraint(equalTo: dateView.bottomAnchor, constant: 13),
        separatorView.leadingAnchor
          .constraint(equalTo: containerView.leadingAnchor),
        separatorView.trailingAnchor
          .constraint(equalTo: containerView.trailingAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        separatorView.topAnchor
          .constraint(equalTo: middleView.bottomAnchor, constant: 12),
        separatorView.leadingAnchor
          .constraint(equalTo: containerView.leadingAnchor, constant: 16),
        separatorView.trailingAnchor
          .constraint(equalTo: containerView.trailingAnchor, constant: -16)
      ])
    }

    return separatorView
  }

  func createMiddleView(parent: UIView) {
    middleView.backgroundColor = UIColor.Zeplin.white
    containerView.addSubview(middleView)

    middleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      middleView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 12),
      middleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      middleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      middleView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func createProductCard() {
    photoView.backgroundColor = UIColor.Zeplin.white
    photoView.layer.cornerRadius = 8
    photoView.clipsToBounds = true
    middleView.addSubview(photoView)

    photoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),
      photoView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
      photoView.widthAnchor.constraint(equalToConstant: 45),
      photoView.heightAnchor.constraint(equalToConstant: 45)
    ])

    productNameView.backgroundColor = UIColor.Zeplin.white
    productNameView.layer.cornerRadius = 6
    productNameView.clipsToBounds = true
    middleView.addSubview(productNameView)

    productNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameView.topAnchor
        .constraint(equalTo: middleView.topAnchor, constant: 8),
      productNameView.leadingAnchor
        .constraint(equalTo: photoView.trailingAnchor, constant: 10),
      productNameView.trailingAnchor
        .constraint(equalTo: middleView.trailingAnchor),
      productNameView.heightAnchor.constraint(equalToConstant: 13)
    ])

    productSubNameView.backgroundColor = UIColor.Zeplin.white
    productSubNameView.layer.cornerRadius = 6
    productSubNameView.clipsToBounds = true
    middleView.addSubview(productSubNameView)

    productSubNameView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productSubNameView.topAnchor
        .constraint(equalTo: productNameView.bottomAnchor, constant: 7),
      productSubNameView.leadingAnchor
        .constraint(equalTo: productNameView.leadingAnchor),
      productSubNameView.trailingAnchor
        .constraint(equalTo: productNameView.centerXAnchor),
      productSubNameView.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

//  func createNoteButton(parent: UIView) {
//    noteButton.titleLabel?.font = .systemFont(ofSize: 14)
//    noteButton.setTitleColor(UIColor.Zeplin.redBranding.withAlphaComponent(0.3), for: .normal)
//    noteButton.setTitle("ver nota fiscal", for: .normal)
//    contentView.addSubview(noteButton)
//
//    noteButton.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      noteButton.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 10),
//      noteButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
//      noteButton.heightAnchor.constraint(equalToConstant: 35)
//    ])
//  }
  func createValueLabel(parent: UIView) {
    priceView.backgroundColor = UIColor.Zeplin.black
    priceView.layer.cornerRadius = 6
    priceView.clipsToBounds = true
    containerView.addSubview(priceView)

    priceView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      priceView.topAnchor.constraint(
        equalTo: parent.bottomAnchor,
        constant: 22
      ),
      priceView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      priceView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -16
      ),
      priceView.heightAnchor.constraint(equalToConstant: 13),
      priceView.bottomAnchor
        .constraint(equalTo: containerView.bottomAnchor, constant: -16)
    ])
  }
}
