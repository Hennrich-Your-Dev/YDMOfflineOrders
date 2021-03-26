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
    createCompareProductsView()
    createCompareProductsViewShadow()
    let label = createCompareProductsLabel()
    createOnlineProductView(parent: label)
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
    storeAndProductView.delegate = self
    view.addSubview(storeAndProductView)

    storeAndProductView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeAndProductView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      storeAndProductView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -20
      ),
      storeAndProductView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
      storeAndProductView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21)
    ])
  }

  func createCompareProductsView() {
    compareProductsView.backgroundColor = UIColor.Zeplin.white
    view.addSubview(compareProductsView)

    compareProductsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      compareProductsView.heightAnchor.constraint(equalToConstant: 144 + view.safeAreaInsets.bottom),
      compareProductsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      compareProductsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      compareProductsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func createCompareProductsViewShadow() {
    compareProductsViewShadow.backgroundColor = .white
    compareProductsViewShadow.layer.applyShadow(y: -2)
    view.addSubview(compareProductsViewShadow)

    compareProductsViewShadow.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      compareProductsViewShadow.bottomAnchor.constraint(equalTo: compareProductsView.topAnchor, constant: 6),
      compareProductsViewShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      compareProductsViewShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      compareProductsViewShadow.heightAnchor.constraint(equalToConstant: 5)
    ])
  }

  func createCompareProductsLabel() -> UILabel {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17)
    label.textColor = UIColor.Zeplin.grayLight
    label.textAlignment = .left
    label.text = "preço comprando online:"
    compareProductsView.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: compareProductsView.topAnchor, constant: 12),
      label.leadingAnchor.constraint(equalTo: compareProductsView.leadingAnchor, constant: 40),
      label.heightAnchor.constraint(equalToConstant: 18)
    ])

    return label
  }

  func createOnlineProductView(parent: UILabel) {
    compareProductsView.addSubview(onlineProductView)
    onlineProductView.layer.shadowOpacity = 0

    onlineProductView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      onlineProductView.topAnchor.constraint(
        equalTo: parent.bottomAnchor
      ),
      onlineProductView.leadingAnchor.constraint(equalTo: compareProductsView.leadingAnchor, constant: 24),
      onlineProductView.trailingAnchor.constraint(equalTo: compareProductsView.trailingAnchor, constant: -24)
    ])
  }
}
