//
//  OrderListConfig.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 23/03/21.
//

import UIKit

import YDB2WModels

enum OrderListType {
  case header
  case row
}

struct OrderListConfig {
  var type: OrderListType
  var headerString: String?
  var order: YDOfflineOrdersOrder?
}
