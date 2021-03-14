//
//  OrderDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import Foundation

import YDExtensions
import YDB2WModels

protocol OrderDetailsNavigation {
  func onBack()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
}

protocol OrderDetailsViewModelDelegate: AnyObject {
  var order: YDOfflineOrdersOrder { get }

  func goBack()
  func openDetailsForProduct(_ product: YDOfflineOrdersProduct)
}

class OrderDetailsViewModel {
  // MARK: Properties
  let navigation: OrderDetailsNavigation
  var order: YDOfflineOrdersOrder

  // MARK: Init
  init(
    navigation: OrderDetailsNavigation,
    order: YDOfflineOrdersOrder
  ) {
    self.navigation = navigation
    self.order = order
  }
}

extension OrderDetailsViewModel: OrderDetailsViewModelDelegate {
  func goBack() {
    navigation.onBack()
  }

  func openDetailsForProduct(_ product: YDOfflineOrdersProduct) {
    navigation.openDetailsForProduct(product)
  }
}
