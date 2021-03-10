//
//  ProductsList.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 10/03/21.
//

import UIKit

import YDUtilities

typealias OrdersList = [Order]

class Order: Decodable {
  var cupom: Int?
  var nfe: String?
  var date: String?
  var totalPrice: Double?
  var storeId: Int?
  var storeName: String?

  // address
  var addressStreet: String?
  var addressCity: String?
  var addressZipcode: String?
  var addressState: String?

  // products
  var products: [Product]?

  // computed variables
  var formatedAddress: String? {
    guard var address = addressStreet else { return nil }

    if let city = addressCity,
       !city.isEmpty {
      address += " - \(city)"
    }

    if let cep = addressZipcode,
       !cep.isEmpty {
      address += " - \(cep)"
    }

    if let state = addressState,
       !state.isEmpty {
      address += ", \(state)"
    }

    return address
  }

  var formatedDate: String? {
    return date?.date(withFormat: "yyyy-MM-dd'T'HH:mm:ss")?.toFormat("dd/MM/YYYY 'às' HH:mm'h'")
  }

  var formatedPrice: String? {
    guard let total = totalPrice else { return nil }
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "BR_pt")

    return formatter.string(from: NSNumber(value: total))
  }

  // MARK: Coding Keys
  enum CodingKeys: String, CodingKey {
    case cupom
    case nfe = "chaveNfe"
    case date = "data"
    case totalPrice = "valorTotal"
    case storeId = "codigoLoja"
    case storeName = "nomeLoja"
    case addressStreet = "logradouro"
    case addressZipcode = "cep"
    case addressCity = "cidade"
    case addressState = "uf"
    case products = "itens"
  }
}

// MARK: Mock
extension Order {
  static func mock() -> [Order] {
    let bundle = Bundle(for: Self.self)

    guard let file = getLocalFile(bundle, fileName: "orders", fileType: "json"),
          let orders = try? JSONDecoder().decode([Order].self, from: file)
      else {
      fatalError()
    }

    return orders
  }
}
