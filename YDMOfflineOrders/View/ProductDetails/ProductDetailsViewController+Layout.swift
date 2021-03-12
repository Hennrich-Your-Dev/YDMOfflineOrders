//
//  OrderDetailsViewController+Layouts.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/02/21.
//

import UIKit

import YDB2WAssets
import YDExtensions

extension ProductDetailsViewController {
  func setUpLayout() {
    view.backgroundColor = UIColor.Zeplin.white
    setUpNavBar()
    createProductCard()
  }

  func setUpNavBar() {
    let backButtonView = UIButton()
    backButtonView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    backButtonView.layer.cornerRadius = 16
    backButtonView.layer.applyShadow()
    backButtonView.backgroundColor = .white
    backButtonView.setImage(Icons.leftArrow, for: .normal)
    backButtonView.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)

    let backButton = UIBarButtonItem()
    backButton.customView = backButtonView

    navigationItem.leftBarButtonItem = backButton

    title = "detalhes do produto"
  }

  @objc func onBackAction(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  func createProductCard() {
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
