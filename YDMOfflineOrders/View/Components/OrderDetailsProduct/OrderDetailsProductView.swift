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
  // MARK: Components
  var container = UIView()
  var photo = UIImageView()
  var photoMask = UIView()
  var name = UILabel()
  var price = UILabel()
  var badgeContainer = UIView()
  var badgeCount = UILabel()

  var shimmerContainer = UIView()
  var shimmerPhoto = UIView()
  var shimmerName = UIView()
  var shimmerPrice = UIView()

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
  func prepareForUse() {
    photo.image = nil
    name.text = nil
    price.text = nil
    badgeContainer.isHidden = true
    badgeCount.text = ""
    container.isHidden = true
    shimmerContainer.isHidden = false
    shimmerPhoto.stopShimmer()
    shimmerName.stopShimmer()
    shimmerPrice.stopShimmer()
  }

  func config(with product: YDOfflineOrdersProduct) {
    if product.products != nil {
      container.isHidden = false
      shimmerContainer.isHidden = true

      photo.setImage(product.image, placeholder: Icons.imagePlaceHolder)
      name.text = product.name?.lowercased()
      price.text = product.formatedPrice

      if product.howMany > 1 {
        badgeContainer.isHidden = false
        badgeCount.text = "\(product.howMany)"
      }
    } else {
      shimmerContainer.isHidden = false
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.shimmerPhoto.startShimmer()
        self.shimmerName.startShimmer()
        self.shimmerPrice.startShimmer()
      }
    }
  }
}

// MARK: Layout
extension OrderDetailsProductView {
  func setUpLayout() {
    createContainer()
    createPhoto()
    createBadge()
    createName()
    createPrice()

    // Shimmer
    createShimmerContainer()
    createShimmerPhoto()
    createShimmerName()
    createShimmerPrice()
  }

  func createContainer() {
    addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func createPhoto() {
    photo.contentMode = .scaleAspectFit
    photo.image = Icons.imagePlaceHolder
    photo.tintColor = UIColor.Zeplin.grayLight
    photo.layer.cornerRadius = 8
    container.addSubview(photo)

    photo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photo.heightAnchor.constraint(equalToConstant: 36),
      photo.widthAnchor.constraint(equalToConstant: 36)
    ])

    photoMask.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    photoMask.layer.opacity = 0.1
    photoMask.layer.cornerRadius = 8
    container.addSubview(photoMask)

    photoMask.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoMask.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      photoMask.leadingAnchor.constraint(
        equalTo: container.leadingAnchor,
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
    container.addSubview(badgeContainer)

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
    container.addSubview(name)

    name.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
      name.leadingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 16),
      name.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
      name.heightAnchor.constraint(equalToConstant: 14)
    ])
  }

  func createPrice() {
    price.font = .systemFont(ofSize: 14, weight: .bold)
    price.textAlignment = .left
    price.textColor = UIColor.Zeplin.black
    container.addSubview(price)

    price.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      price.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
      price.leadingAnchor.constraint(equalTo: photoMask.trailingAnchor, constant: 16),
      price.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
      price.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  // Shimmer
  func createShimmerContainer() {
    addSubview(shimmerContainer)

    shimmerContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerContainer.topAnchor.constraint(equalTo: topAnchor),
      shimmerContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
      shimmerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      shimmerContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  func createShimmerPhoto() {
    shimmerPhoto.backgroundColor = .white
    shimmerPhoto.layer.cornerRadius = 8
    shimmerContainer.addSubview(shimmerPhoto)

    shimmerPhoto.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPhoto.centerYAnchor.constraint(equalTo: shimmerContainer.centerYAnchor),
      shimmerPhoto.leadingAnchor.constraint(
        equalTo: shimmerContainer.leadingAnchor,
        constant: 16
      ),
      shimmerPhoto.heightAnchor.constraint(equalToConstant: 45),
      shimmerPhoto.widthAnchor.constraint(equalToConstant: 45)
    ])
  }

  func createShimmerName() {
    shimmerName.backgroundColor = .white
    shimmerName.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerName)

    shimmerName.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerName.topAnchor.constraint(equalTo: shimmerPhoto.topAnchor, constant: 7),
      shimmerName.leadingAnchor.constraint(equalTo: shimmerPhoto.trailingAnchor, constant: 16),
      shimmerName.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor,
        constant: -24
      ),
      shimmerName.heightAnchor.constraint(equalToConstant: 13)
    ])
  }

  func createShimmerPrice() {
    shimmerPrice.backgroundColor = .white
    shimmerPrice.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerPrice)

    shimmerPrice.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerPrice.topAnchor.constraint(equalTo: shimmerName.bottomAnchor, constant: 6),
      shimmerPrice.leadingAnchor.constraint(
        equalTo: shimmerPhoto.trailingAnchor,
        constant: 16
      ),
      shimmerPrice.widthAnchor.constraint(equalToConstant: 80),
      shimmerPrice.heightAnchor.constraint(equalToConstant: 13)
    ])
  }
}
