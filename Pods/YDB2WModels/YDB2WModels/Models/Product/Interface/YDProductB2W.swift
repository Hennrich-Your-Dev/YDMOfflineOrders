//
//  YDProductB2W.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation

public class YDProductB2W: Codable {

  private let details: [YDProductDetails]

  private let results: [YDProductB2WResult]

  public var product: YDProduct?

  // CodingKeys
  enum CodingKeys: String, CodingKey {
    case details
    case results = "result"
  }

  //
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    details = try container.decode([YDProductDetails].self, forKey: .details)
    guard let details = details.first,
          details.success
    else {
      results = []
      return
    }

    results = try container.decode([YDProductB2WResult].self, forKey: .results)
    let result = results.first

    var price: Double?

    if let offer = result?.offer?.offers?.first {
      price = offer.salesPrice
    }

    product = YDProduct(
      attributes: result?.attributes,
      description: result?.description,
      id: result?.id,
      images: result?.images,
      name: result?.name,
      price: price,
      rating: result?.rating,
      isAvailable: price != nil
    )
  }

}

public class YDProductB2WOffers: Codable {
  public let offers: [YDProductB2WOffer]?

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    offers = try container.decode([YDProductB2WOffer].self, forKey: .offers)
  }
}

public class YDProductB2WOffer: Codable {
  public let salesPrice: Double
}

public class YDProductB2WResult: YDProduct {
  public let offer: YDProductB2WOffers?

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    offer = try container.decode(YDProductB2WOffers.self, forKey: .offer)

    try super.init(from: decoder)
  }

  enum CodingKeys: CodingKey {
    case offer
  }
}
