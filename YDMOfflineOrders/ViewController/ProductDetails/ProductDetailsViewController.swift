//
//  ProductDetailsViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/02/21.
//

import UIKit

import YDB2WComponents
import YDB2WModels

class ProductDetailsViewController: UIViewController {
  // MARK: Properties
  var productOnlineOffline: YDProductOnlineOffline? {
    didSet {
      updateLayoutWithOfflineProduct()
      updateLayoutWithOnlineProduct()
    }
  }
  var store: YDStore? {
    didSet {
      updateLayoutWithStore()
    }
  }

  // MARK: Components
  let storeAndProductView = YDStoreAndProductView()
  let compareProductsView = UIView()
  let compareProductsViewShadow = UIView()
  let onlineProductView = YDProductCardView()

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
  }

  // MARK: Actions
  private func updateLayoutWithOfflineProduct() {
    guard let product = productOnlineOffline?.offline else {
      return
    }

    storeAndProductView.product = product
  }

  private func updateLayoutWithOnlineProduct() {
    guard let product = productOnlineOffline?.online else {
      compareProductViewVisibility(show: false)
      return
    }

    compareProductViewVisibility(show: true)
    onlineProductView.product = product
  }

  private func updateLayoutWithStore() {
    guard let store = store else { return }
    storeAndProductView.store = store
  }

  func compareProductViewVisibility(show: Bool) {
    compareProductsView.isHidden = !show
    compareProductsViewShadow.isHidden = !show
  }
}
