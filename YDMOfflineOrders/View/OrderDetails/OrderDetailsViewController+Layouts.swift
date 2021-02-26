//
//  OrderDetailsViewController+Layouts.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/02/21.
//

import UIKit

extension OrderDetailsViewController {
  func setUpLayout() {
    createProductCard()
  }

  func createProductCard() {
    productCard = OrderDetailsProductCard()
    view.addSubview(productCard)

    productCard.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productCard.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      productCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      productCard.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}
