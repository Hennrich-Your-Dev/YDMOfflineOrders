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

  // MARK: Mock
  init(mock: Bool = true) {
    self.image = "https://images-americanas.b2w.io/produtos/01/00/img/2416847/5/2416847547_1GG.jpg"
    self.name = .loremIpsum()
    self.howMany = [1, 3].randomElement()!
    self.ean = "7891010249403"
    self.totalPrice = 4.59
  }
}
