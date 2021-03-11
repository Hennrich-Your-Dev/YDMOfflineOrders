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
  var orderList: Binder<[[String: OrdersList]]> { get }

  subscript(section: Int) -> [Order]? { get }

  func getOrderList()
}

class YDMOfflineOrdersViewModel {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)

  var error: Binder<String> = Binder("")
  var orderList: Binder<[[String: OrdersList]]> = Binder([])
  var orders: OrdersList = []

  // MARK: Actions
  private func sortOrdersList() {
    let sorted = orders.sorted { (lhs, rhs) -> Bool in
      guard let dateLhs = lhs.dateWithDateType else { return false }
      guard let dateRhs = rhs.dateWithDateType else { return true }

      return dateLhs.compare(dateRhs) == .orderedDescending
    }

    for order in sorted {
      guard let sectionDate = order.formatedDateSection else { continue }

      if let index = orderList.value.firstIndex(where: { $0.keys.first == sectionDate }),
         var arr = orderList.value.at(index) {
        //
        arr[sectionDate]?.append(order)
        orderList.value[index] = arr
      } else {
        orderList.value.append([sectionDate: [order]])
      }
    }
  }
}

// MARK: Extension
extension YDMOfflineOrdersViewModel: YDMOfflineOrdersViewModelDelegate {

  subscript(section: Int) -> [Order]? {
    return orderList.value.at(section)?.values.first
  }

  func getOrderList() {
    orders = Order.mock()
    sortOrdersList()
  }
}
