//
//  Product.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import Foundation

class Product: Decodable {
  var image: String?
  var name: String?
  var howMany: Int = 1
  var ean: String?
  var totalPrice: Double

  // MARK: Coding Keys
  enum CodingKeys: String, CodingKey {
    case image
    case name
    case ean
    case howMany = "qtde"
    case totalPrice = "valorTotalItem"
  }
}
