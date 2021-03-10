//
//  YDMOfflineOrdersViewModel.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import Foundation

import YDUtilities
import YDExtensions

protocol YDMOfflineOrdersViewModelDelegate: AnyObject {
  var error: Binder<String> { get }
  var orderList: Binder<OrdersList> { get }

  func getOrderList()
}

class YDMOfflineOrdersViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)

  var error: Binder<String> = Binder("")
  var orderList: Binder<OrdersList> = Binder([])

  // MARK: Init
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {
  func getOrderList() {
    orderList.value = Order.mock()
  }
}
