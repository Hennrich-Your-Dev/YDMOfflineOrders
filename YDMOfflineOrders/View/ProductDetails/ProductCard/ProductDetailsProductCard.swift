//
//  OrderDetailsProductCard.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/02/21.
//

import UIKit

import Cosmos
import YDExtensions
import YDB2WAssets

class ProductDetailsProductCard: UIView {
  // MARK: Properties
  var photoImageView = UIImageView()
  var productNameLabel = UILabel()
  var productPriceLabel = UILabel()
  var ratingView = CosmosView()

  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.Zeplin.white
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
}

// MARK: Layout
extension ProductDetailsProductCard {
  func setUpLayout() {
    createPhotoImageView()
    createProductNameLabel()
    createValueLabel()
    createRatingView()
  }

  func createPhotoImageView() {
    let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
    photoImageView.frame = rect
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = Images.basket
    addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      photoImageView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      photoImageView.heightAnchor.constraint(equalToConstant: 80),
      photoImageView.widthAnchor.constraint(equalToConstant: 80)
    ])

    photoImageView.layer.cornerRadius = 8

    let maskLayer = CALayer()
    maskLayer.frame = photoImageView.frame
    maskLayer.cornerRadius = 8
    maskLayer.opacity = 0.1
    maskLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.7).cgColor

    photoImageView.layer.insertSublayer(maskLayer, at: 0)
  }

  func createProductNameLabel() {
    productNameLabel.font = .systemFont(ofSize: 14)
    productNameLabel.textAlignment = .left
    productNameLabel.textColor = UIColor.Zeplin.grayLight
    productNameLabel.numberOfLines = 2
    productNameLabel.text = .loremIpsum()
    addSubview(productNameLabel)

    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 12
      ),
      productNameLabel.leadingAnchor.constraint(
        equalTo: self.photoImageView.trailingAnchor,
        constant: 16
      ),
      productNameLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -8
      )
    ])
  }

  func createValueLabel() {
    productPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    productPriceLabel.textAlignment = .left
    productPriceLabel.textColor = UIColor.Zeplin.black
    productPriceLabel.numberOfLines = 1
    productPriceLabel.text = "R$ 41,91"
    addSubview(productPriceLabel)

    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      productPriceLabel.leadingAnchor.constraint(
        equalTo: self.photoImageView.trailingAnchor,
        constant: 16
      ),
      productPriceLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -8
      ),
      productPriceLabel.heightAnchor.constraint(equalToConstant: 28)
    ])

    productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }

  func createRatingView() {
    addSubview(ratingView)

    var settings = CosmosSettings()
    settings.emptyImage = Images.starGrey
    settings.filledImage = Images.starYellow
    settings.fillMode = .half
    settings.starMargin = 0
    settings.starSize = 12
    settings.totalStars = 5
    settings.textMargin = 6
    settings.textColor = UIColor.Zeplin.grayLight
    settings.textFont = .systemFont(ofSize: 12)

    ratingView.settings = settings

    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(
        greaterThanOrEqualTo: productNameLabel.bottomAnchor,
        constant: 4
      ),
      ratingView.leadingAnchor.constraint(
        equalTo: self.photoImageView.trailingAnchor,
        constant: 16
      ),
      ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      ratingView.heightAnchor.constraint(equalToConstant: 15),
      ratingView.bottomAnchor.constraint(equalTo: productPriceLabel.topAnchor, constant: -5)
    ])

    ratingView.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
}
