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
    contentView.layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
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
    titleLabel = createTitleLabel()
    subTitleLabel = createSubTitleLabel(parent: titleLabel)
    let separator = createSeparator(parent: subTitleLabel)
    photoImageView = createPhotoImageView(parent: separator)
  }
}

// MARK: Layout
extension OrdersCollectionViewCell {
  func createTitleLabel() -> UILabel {
    let titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    titleLabel.textAlignment = .left
    titleLabel.textColor = UIColor.Zeplin.black
    titleLabel.numberOfLines = 1
    titleLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      titleLabel.heightAnchor.constraint(equalToConstant: 18)
    ])

    return titleLabel
  }

  func createSubTitleLabel(parent: UIView) -> UILabel {
    let subTitleLabel = UILabel()
    subTitleLabel.font = .systemFont(ofSize: 14)
    subTitleLabel.textAlignment = .left
    subTitleLabel.textColor = UIColor.Zeplin.grayLight
    subTitleLabel.numberOfLines = 1
    subTitleLabel.text = .loremIpsum(ofLength: 50)
    contentView.addSubview(subTitleLabel)

    subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subTitleLabel.topAnchor.constraint(equalTo:  parent.bottomAnchor, constant: 3),
      subTitleLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
      subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -8),
      subTitleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])

    return subTitleLabel
  }

  func createSeparator(parent: UIView) -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.Zeplin.grayDisabled
    contentView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo:  parent.bottomAnchor, constant: 13),
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1)
    ])

    return separatorView
  }

  func createPhotoImageView(parent: UIView) -> UIImageView {
    let photoImageView = UIImageView()
    photoImageView.contentMode = .scaleAspectFit
    photoImageView.image = Images.clipboard
    photoImageView.backgroundColor = UIColor.Zeplin.white
    contentView.addSubview(photoImageView)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo:  parent.bottomAnchor, constant: 13),
      photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      photoImageView.heightAnchor.constraint(equalToConstant: 80),
      photoImageView.widthAnchor.constraint(equalToConstant: 80)
    ])

    photoImageView.layer.cornerRadius = 8

    let mask = CAShapeLayer()
    mask.frame = photoImageView.frame
    mask.cornerRadius = 8
    mask.backgroundColor = UIColor.gray.withAlphaComponent(0.7).cgColor
    mask.opacity = 0.7

    photoImageView.layer.mask = mask

    return photoImageView
  }
}
