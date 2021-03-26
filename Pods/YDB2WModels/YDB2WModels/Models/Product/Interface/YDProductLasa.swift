//
//  YDProductLasa.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation

public class YDProductLasa: Codable {

  private let details: YDProductDetails

  private let result: YDProductLasaResult?

  public var product: YDProduct?

  // CodingKeys
  enum CodingKeys: CodingKey {
    case details
    case result
  }

  //
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    details = try container.decode(YDProductDetails.self, forKey: .details)

    if !details.success {
      result = nil
      return
    }

    // Accept Array or Object
    if let response = try? container.decode([YDProductLasaResult].self, forKey: .result).first {
      result = response
    } else {
      result = try? container.decode(YDProductLasaResult.self, forKey: .result)
    }

    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.locale = Locale(identifier: "pt_BR")

    product = YDProduct(
      attributes: nil,
      description: result?.descricao,
      id: nil,
      images: nil,
      name: nil,
      price: formatter.number(from: result?.preco ?? "")?.doubleValue,
      rating: nil
    )
  }
}

public class YDProductLasaResult: Codable {
  public let descricao: String?
  public let preco: String?

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    descricao = try? container.decode(String.self, forKey: .descricao)
    preco = try? container.decode(String.self, forKey: .preco)
  }

  enum CodingKeys: CodingKey {
    case descricao
    case preco
  }
}
