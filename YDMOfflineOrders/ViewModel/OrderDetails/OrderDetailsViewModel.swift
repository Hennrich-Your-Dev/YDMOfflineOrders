//
//  OrderDetailsViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 12/03/21.
//

import Foundation

import YDExtensions
import YDB2WModels

protocol OrderDetailsNavigation {}

protocol OrderDetailsViewModelDelegate: AnyObject {
  func getOrder() -> YDOfflineOrdersOrder
}

class OrderDetailsViewModel {
  // MARK: Properties
  let navigation: OrderDetailsNavigation
  let order: YDOfflineOrdersOrder

  // MARK: Init
  init(navigation: OrderDetailsNavigation,
       order: YDOfflineOrdersOrder) {
    self.navigation = navigation
    self.order = order
  }
}

extension OrderDetailsViewModel: OrderDetailsViewModelDelegate {
  func getOrder() -> YDOfflineOrdersOrder {
    return order
  }
}
