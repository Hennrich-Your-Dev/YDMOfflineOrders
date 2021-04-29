//
//  OrdersHeaderCollectionViewCell.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 30/03/21.
//

import UIKit

class OrdersHeaderCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let dateLabel = UILabel()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
    ])

    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout
extension OrdersHeaderCollectionViewCell {
  func setUpLayout() {
    let dateContainer = UIView()
    dateContainer.backgroundColor = UIColor.Zeplin.white
    dateContainer.layer.cornerRadius = 10
    dateContainer.layer.applyShadow(alpha: 0.15, x: 0, y: 0, blur: 20)
    contentView.addSubview(dateContainer)

    dateContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateContainer.heightAnchor.constraint(equalToConstant: 20),
      dateContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      dateContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    dateLabel.font = .systemFont(ofSize: 12)
    dateLabel.textColor = UIColor.Zeplin.grayLight
    dateLabel.textAlignment = .center
    dateContainer.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
      dateLabel.leadingAnchor.constraint(
        equalTo: dateContainer.leadingAnchor,
        constant: 27
      ),
      dateLabel.trailingAnchor.constraint(
        equalTo: dateContainer.trailingAnchor,
        constant: -27
      )
    ])
  }
}
