//
//  YDProductCardView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import Cosmos
import YDExtensions
import YDB2WAssets
import YDB2WModels

public class YDProductCardView: UIView {
  // MARK: Properties
  public var product: YDProduct? {
    didSet {
      updateLayoutWithProduct()
    }
  }

  // MARK: Components
  private var photoImageView = UIImageView()
  private var photoImageMask = UIView()
  private var productNameLabel = UILabel()
  private var productPriceLabel = UILabel()
  private var ratingView = CosmosView()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.Zeplin.white
    layer.applyShadow(x: 0, y: 0, blur: 20)
    heightAnchor.constraint(equalToConstant: 120).isActive = true
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  private func updateLayoutWithProduct() {
    guard let product = self.product else { return }

    photoImageView.setImage(product.images?.first?.medium ?? product.images?.first?.small)
    productNameLabel.text = product.name
    productPriceLabel.text = product.getPrice()

    if let rate = product.rating?.average,
       rate > 0,
       let rateText = product.rating?.recommendations {
      ratingView.isHidden = false
      ratingView.rating = rate
      ratingView.text = "(\(rateText)"
    } else {
      ratingView.isHidden = true
    }
  }
}

// MARK: Layout
extension YDProductCardView {
  private func setUpLayout() {
    createPhotoImageView()
    createProductNameLabel()
    createValueLabel()
    createRatingView()
  }

  private func createPhotoImageView() {
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = Icons.imagePlaceHolder
    photoImageView.tintColor = UIColor.Zeplin.grayLight
    photoImageView.layer.cornerRadius = 8
    addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.heightAnchor.constraint(equalToConstant: 70),
      photoImageView.widthAnchor.constraint(equalToConstant: 70)
    ])

    photoImageMask.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    photoImageMask.layer.opacity = 0.1
    photoImageMask.layer.cornerRadius = 8
    addSubview(photoImageMask)

    photoImageMask.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageMask.centerYAnchor.constraint(equalTo: centerYAnchor),
      photoImageMask.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 16
      ),
      photoImageMask.heightAnchor.constraint(equalToConstant: 80),
      photoImageMask.widthAnchor.constraint(equalToConstant: 80)
    ])

    photoImageView.centerYAnchor.constraint(equalTo: photoImageMask.centerYAnchor).isActive = true
    photoImageView.centerXAnchor.constraint(equalTo: photoImageMask.centerXAnchor).isActive = true
  }

  private func createProductNameLabel() {
    productNameLabel.font = .systemFont(ofSize: 14)
    productNameLabel.textAlignment = .left
    productNameLabel.textColor = UIColor.Zeplin.grayLight
    productNameLabel.numberOfLines = 2
    productNameLabel.text = .loremIpsum()
    addSubview(productNameLabel)

    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(equalTo: photoImageMask.topAnchor),
      productNameLabel.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      productNameLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -8
      )
    ])
  }

  private func createValueLabel() {
    productPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    productPriceLabel.textAlignment = .left
    productPriceLabel.textColor = UIColor.Zeplin.black
    productPriceLabel.numberOfLines = 1
    productPriceLabel.text = "R$ 38,99"
    addSubview(productPriceLabel)

    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.bottomAnchor.constraint(equalTo: photoImageMask.bottomAnchor),
      productPriceLabel.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      productPriceLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -8
      ),
      productPriceLabel.heightAnchor.constraint(equalToConstant: 24)
    ])

    productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }

  private func createRatingView() {
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
    settings.updateOnTouch = false

    ratingView.settings = settings
    ratingView.text = "(456)"

    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.topAnchor.constraint(
        greaterThanOrEqualTo: productNameLabel.bottomAnchor,
        constant: 4
      ),
      ratingView.leadingAnchor.constraint(
        equalTo: photoImageMask.trailingAnchor,
        constant: 16
      ),
      ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      ratingView.heightAnchor.constraint(equalToConstant: 13),
      ratingView.bottomAnchor.constraint(equalTo: productPriceLabel.topAnchor, constant: -5)
    ])

    ratingView.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
}
