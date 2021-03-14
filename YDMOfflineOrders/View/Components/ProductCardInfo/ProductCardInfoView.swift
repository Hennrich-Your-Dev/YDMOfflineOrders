//
//  ProductCardInfoView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels

// MARK: Product Info
class ProductCardInfoView: UIView {
  // MARK: Properties
  var photo = UIImageView()
  var name = UILabel()
  var badgeContainer = UIView()
  var badgeCount = UILabel()
  var phantomButton = UIButton()

  var currentProduct: YDOfflineOrdersProduct?

  // MARK: Init
  init() {
    super.init(frame: .zero)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func config(with product: YDOfflineOrdersProduct) {
    currentProduct = product

    photo.setImage(product.image)
    name.text = product.name

    if product.howMany > 1 {
      badgeContainer.isHidden = false
      badgeCount.text = "\(product.howMany)"
    }
  }

  @objc func onButtonAction(_ sender: UIButton) {
    guard let product = currentProduct else { return }
    print(product.ean)
  }
}

// MARK: Layout
extension ProductCardInfoView {
  func setUpLayout() {
    createPhoto()
    createBadge()
    createName()
    createPhantomButton()
  }

  func createPhoto() {
    let rect = CGRect(x: 0, y: 0, width: 45, height: 45)
    photo.frame = rect
    photo.contentMode = .scaleAspectFit
    photo.image = Icons.imagePlaceHolder
    photo.tintColor = UIColor.Zeplin.grayLight
    addSubview(photo)

    photo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photo.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      photo.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      photo.heightAnchor.constraint(equalToConstant: 45),
      photo.widthAnchor.constraint(equalToConstant: 45)
    ])

    photo.layer.cornerRadius = 8

    let maskLayer = CALayer()
    maskLayer.frame = photo.frame
    maskLayer.cornerRadius = 8
    maskLayer.opacity = 0.1
    maskLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.7).cgColor

    photo.layer.insertSublayer(maskLayer, at: 0)
  }

  func createBadge() {
    badgeContainer.backgroundColor = UIColor.Zeplin.redBranding
    badgeContainer.layer.cornerRadius = 8.5
    badgeContainer.isHidden = true
    addSubview(badgeContainer)

    badgeContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeContainer.topAnchor.constraint(equalTo: photo.topAnchor, constant: -5),
      badgeContainer.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 5),
      badgeContainer.widthAnchor.constraint(equalToConstant: 17),
      badgeContainer.heightAnchor.constraint(equalToConstant: 17)
    ])

    badgeCount.textColor = UIColor.Zeplin.white
    badgeCount.textAlignment = .center
    badgeCount.font = .systemFont(ofSize: 13)
    badgeContainer.addSubview(badgeCount)

    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeCount.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor),
      badgeCount.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor),
      badgeCount.topAnchor.constraint(equalTo: badgeContainer.topAnchor),
      badgeCount.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor)
    ])
  }

  func createName() {
    name.font = .systemFont(ofSize: 14)
    name.textAlignment = .left
    name.textColor = UIColor.Zeplin.grayLight
    name.numberOfLines = 2
    name.text = .loremIpsum()
    addSubview(name)

    name.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      name.centerYAnchor.constraint(equalTo: photo.centerYAnchor),
      name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 10),
      name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }

  func createPhantomButton() {
    addSubview(phantomButton)

    phantomButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      phantomButton.topAnchor.constraint(equalTo: photo.topAnchor),
      phantomButton.leadingAnchor.constraint(equalTo: photo.leadingAnchor),
      phantomButton.trailingAnchor.constraint(equalTo: name.trailingAnchor),
      phantomButton.bottomAnchor.constraint(equalTo: photo.bottomAnchor)
    ])
//    print("phantomButton \(phantomButton.isUserInteractionEnabled)")
    phantomButton.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }
}
