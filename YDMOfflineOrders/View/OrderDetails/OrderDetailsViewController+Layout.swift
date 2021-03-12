//
//  OrderDetailsViewController+Layout.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import UIKit

import YDExtensions
import YDB2WAssets

extension OrderDetailsViewController {
  func setUpLayout() {
    setUpNavBar()
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

    title = "detalhes da compra"
  }

  @objc func onBackAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
