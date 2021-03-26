//
//  OrderDetailsProductView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets
import YDB2WModels

class OrderDetailsProductView: UIView {
  // MARK: Properties
  var photo = UIImageView()
  var photoMask = UIView()
  var name = UILabel()
  var price = UILabel()
  var badgeContainer = UIView()
  var badgeCount = UILabel()

  // MARK: Init
  init() {
    super.init(frame: .zero)

    backgroundColor = .clear
    layer.masksToBounds = false

    translatesAutoresizingMaskIntoConstraints = true
    heightAnchor.constraint(equalToConstant: 50).isActive = true

    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func config(with product: YDOfflineOrdersProduct) {
    photo.setImage(product.image)
    name.text = product.name
    price.text = product.formatedPrice

    if product.howMany > 1 {
      badgeContainer.isHidden = false
      badgeCount.text = "\(product.howMany)"
    }
  }
}

// MARK: Layout
extension OrderDetailsProductView {
  func setUpLayout() {
    createPhoto()
    createBadge()
    createName()
    createPrice()
  }

  func createPhoto() {
    photo.contentMode = .scaleAspectFit
    photo.image = Icons.imagePlaceHolder
    photo.tintColor = UIColor.Zeplin.grayLight
    photo.layer.cornerRadius = 8
    addSubview(photo)

    photo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photo.heightAnchor.constraint(equalToConstant: 36),
      photo.widthAnchor.constraint(equalToConstant: 36)
    ])

    photoMask.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    photoMask.layer.opacity = 0.1
    photoMask.layer.cornerRadius = 8
    addSubview(photoMask)

    photoMask.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoMask.centerYAnchor.constraint(equalTo: centerYAnchor),
      photoMask.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      photoMask.heightAnchor.constraint(equalToConstant: 45),
      photoMask.widthAnchor.constraint(equalToConstant: 45)
    ])

    photo.centerYAnchor.constraint(equalTo: photoMask.centerYAnchor).isActive = true
    photo.centerXAnchor.constraint(equalTo: photoMask.centerXAnchor).isActive = true
  }

  func createBadge() {
    badgeContainer.backgroundColor = UIColor.Zeplin.redBranding
    badgeContainer.layer.cornerRadius = 8.5
    badgeContainer.isHidden = true
    addSubview(badgeContainer)

    badgeContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeContainer.topAnchor.constraint(equalTo: photoMask.topAnchor, constant: -5),
      badgeContainer.trailingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 5),
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
    addSubview(name)

    name.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      name.leadingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 16),
      name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }

  func createPrice() {
    price.font = .systemFont(ofSize: 14, weight: .bold)
    price.textAlignment = .left
    price.textColor = UIColor.Zeplin.black
    addSubview(price)

    price.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      price.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
      price.leadingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 16),
      price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      price.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
}
