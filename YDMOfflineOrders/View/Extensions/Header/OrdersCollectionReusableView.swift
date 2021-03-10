//
//  OrdersCollectionReusableView.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 24/02/21.
//

import UIKit

import YDExtensions

class OrdersCollectionReusableView: UICollectionReusableView {
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OrdersCollectionReusableView {
  func setUpLayout() {
    let header = UICollectionReusableView()
    header.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 20)
    header.layer.masksToBounds = false
    addSubview(header)

    header.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      header.leadingAnchor.constraint(equalTo: leadingAnchor),
      header.trailingAnchor.constraint(equalTo: trailingAnchor),
      header.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])

    let dateContainer = UIView()
    dateContainer.backgroundColor = UIColor.Zeplin.white
    dateContainer.layer.cornerRadius = 10
    dateContainer.layer.applyShadow()
    header.addSubview(dateContainer)

    dateContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateContainer.heightAnchor.constraint(equalToConstant: 20),
      dateContainer.centerXAnchor.constraint(equalTo: header.centerXAnchor),
      dateContainer.centerYAnchor.constraint(equalTo: header.centerYAnchor)
    ])

    let dateLabel = UILabel()
    dateLabel.font = .systemFont(ofSize: 12)
    dateLabel.textColor = UIColor.Zeplin.grayLight
    dateLabel.textAlignment = .center
    dateLabel.text = "abril de 2020"
    dateContainer.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
      dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor,
                                         constant: 27),
      dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor,
                                         constant: -27)
    ])
  }
}
