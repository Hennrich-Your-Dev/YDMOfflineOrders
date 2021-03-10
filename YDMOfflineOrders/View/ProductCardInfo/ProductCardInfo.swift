//
//  ProductCardInfo.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets

// MARK: Product Info
class ProductCardInfo: UIView {
  // MARK: Properties
  var photo = UIImageView()
  var name = UILabel()
  var badgeContainer = UIView()
  var badgeCount = UILabel()

  // MARK: Init
  init() {
    super.init(frame: .zero)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout
extension ProductCardInfo {
  func setUpLayout() {
    createPhoto()
    createBadge()
    createName()
  }

  func createPhoto() {
    let rect = CGRect(x: 0, y: 0, width: 45, height: 45)
    photo.frame = rect
    photo.contentMode = .scaleAspectFit
    photo.image = Images.basket
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
    badgeCount.text = "3"
    badgeContainer.addSubview(badgeCount)

    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      badgeCount.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor),
      badgeCount.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor)
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
}
