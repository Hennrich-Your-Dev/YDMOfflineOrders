//
//  OrderListConfig.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 23/03/21.
//

import UIKit

import YDB2WModels

struct OrderListConfig {
  var date: String
  var section: Int?
  var orders: [YDOfflineOrdersOrder]
}
