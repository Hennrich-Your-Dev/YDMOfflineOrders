//
//  OrdersCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 22/02/21.
//

import UIKit

import YDExtensions
import YDB2WAssets

class OrdersCollectionViewCell: UICollectionViewCell {
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
    contentView.layer.masksToBounds = false

    layer.masksToBounds = false
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func setUpLayout() {
    createTitleLabel()
    createSubTitleLabel()

    let separator = createSeparator()

    createPhotoImageView(parent: separator)

    createDateLabel(parent: separator)
    createProductNameLabel()

    let valueTotalLabel = createValueTotalLabel()
    createValueLabel(parent: valueTotalLabel)
    createNoteLabel()
  }
}

// MARK: Layout
extension OrdersCollectionViewCell {
  func createTitleLabel() {
    self.titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    titleLabel.textAlignment = .left
    titleLabel.textColor = UIColor.Zeplin.black
    titleLabel.numberOfLines = 1
    titleLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      titleLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func createSubTitleLabel() {
    self.subTitleLabel = UILabel()
    subTitleLabel.font = .systemFont(ofSize: 14)
    subTitleLabel.textAlignment = .left
    subTitleLabel.textColor = UIColor.Zeplin.grayLight
    subTitleLabel.numberOfLines = 1
    subTitleLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(subTitleLabel)

    subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 3),
      subTitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
      subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      subTitleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createSeparator() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.Zeplin.grayDisabled
    contentView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 13),
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])

    return separatorView
  }

  func createPhotoImageView(parent: UIView) {
    let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
    self.photoImageView = UIImageView(frame: rect)
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = Images.basket
    contentView.addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 13),
      photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
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

  func createDateLabel(parent: UIView) {
    self.dateLabel = UILabel()
    dateLabel.font = .systemFont(ofSize: 13)
    dateLabel.textAlignment = .left
    dateLabel.textColor = UIColor.Zeplin.grayLight
    dateLabel.numberOfLines = 1
    dateLabel.text = "07/04/2020 às 14:22h"
    contentView.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo:  parent.bottomAnchor, constant: 13),
      dateLabel.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      dateLabel.heightAnchor.constraint(equalToConstant: 15)
    ])
  }

  func createProductNameLabel() {
    self.productNameLabel = UILabel()
    productNameLabel.font = .systemFont(ofSize: 14)
    productNameLabel.textAlignment = .left
    productNameLabel.textColor = UIColor.Zeplin.grayLight
    productNameLabel.numberOfLines = 1
    productNameLabel.text = .loremIpsum()
    contentView.addSubview(productNameLabel)

    productNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productNameLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor,
                                            constant: 3),
      productNameLabel.leadingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor),
      productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      productNameLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func createValueTotalLabel() -> UILabel {
    let valueTotalLabel = UILabel()
    valueTotalLabel.font = .systemFont(ofSize: 12)
    valueTotalLabel.textAlignment = .left
    valueTotalLabel.textColor = UIColor.Zeplin.grayLight
    valueTotalLabel.numberOfLines = 1
    valueTotalLabel.text = "total:"
    contentView.addSubview(valueTotalLabel)

    valueTotalLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      valueTotalLabel.topAnchor.constraint(equalTo:  self.productNameLabel.bottomAnchor,
                                            constant: 7),
      valueTotalLabel.leadingAnchor.constraint(equalTo: self.productNameLabel.leadingAnchor),
      valueTotalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      valueTotalLabel.heightAnchor.constraint(equalToConstant: 14)
    ])

    return valueTotalLabel
  }

  func createValueLabel(parent: UIView) {
    self.productPriceLabel = UILabel()
    productPriceLabel.font = .systemFont(ofSize: 24, weight: .bold)
    productPriceLabel.textAlignment = .left
    productPriceLabel.textColor = UIColor.Zeplin.black
    productPriceLabel.numberOfLines = 1
    productPriceLabel.text = "R$ 41,91"
    contentView.addSubview(productPriceLabel)

    let percent = contentView.frame.size.width * 0.27

    productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productPriceLabel.topAnchor.constraint(equalTo:  parent.bottomAnchor,
                                            constant: 1),
      productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -16),
      productPriceLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -percent),
      productPriceLabel.heightAnchor.constraint(equalToConstant: 28)
    ])

    productPriceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }

  func createNoteLabel() {
    let noteLabel = UILabel()
    noteLabel.font = .systemFont(ofSize: 14)
    noteLabel.textAlignment = .right
    noteLabel.textColor = UIColor.Zeplin.redBranding
    noteLabel.numberOfLines = 1
    noteLabel.text = "ver nota fiscal"
    contentView.addSubview(noteLabel)

    noteLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      noteLabel.centerYAnchor.constraint(equalTo: self.productPriceLabel.centerYAnchor),
      noteLabel.leadingAnchor.constraint(equalTo: self.productPriceLabel.trailingAnchor,
                                         constant: 1),
      noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      noteLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
    noteLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
  }
}
