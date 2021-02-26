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

class OrderDetailsProductCard: UIView {
  // MARK: Properties
  var titleLabel: UILabel!
  var subTitleLabel: UILabel!
  var photoImageView: UIImageView!
  var dateLabel: UILabel!
  var productNameLabel: UILabel!
  var productPriceLabel: UILabel!

  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
}

// MARK: Layout
extension OrderDetailsProductCard {
  func setUpLayout() {
    createPhotoImageView()
    createProductNameLabel()
  }

  func createPhotoImageView() {
    let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
    self.photoImageView = UIImageView(frame: rect)
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = Images.basket
    addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: 16),
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
    self.productNameLabel = UILabel()
    productNameLabel.font = .systemFont(ofSize: 14)
    productNameLabel.textAlignment = .left
    productNameLabel.textColor = UIColor.Zeplin.grayLight
    productNameLabel.numberOfLines = 2
    productNameLabel.text = .loremIpsum()
    addSubview(productNameLabel)

    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 12),
      productNameLabel.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor,
                                                constant: 16),
      productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -8)
    ])
  }
}
