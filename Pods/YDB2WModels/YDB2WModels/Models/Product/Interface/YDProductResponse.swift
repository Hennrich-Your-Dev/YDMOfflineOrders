//
//  YDProductResponse.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 26/03/21.
//

import Foundation

public class YDProductResponse: Codable {
  // CodingKeys
  enum CodingKeys: String, CodingKey {
    case offerB2W = "product-b2w"
    case offerLasa = "product-lasa"
  }

  // Properties
  var offerB2W: YDProductB2W?
  var offerLasa: YDProductLasa?

  // Init from decoder
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    offerB2W = try? container.decode(YDProductB2W.self, forKey: .offerB2W)
    offerLasa = try? container.decode(YDProductLasa.self, forKey: .offerLasa)

    if offerB2W?.product?.id == nil &&
        offerLasa?.product?.id == nil {
      offerB2W = nil
      offerLasa = nil
      return
    }

    var product: YDProduct?

    if let productB2W = offerB2W?.product {
      product = productB2W
    } else if let productLasa = offerLasa?.product {
      product = productLasa
    }

    if offerLasa?.product == nil {
      if offerB2W?.product?.id == nil { return }

      offerLasa?.product = YDProduct(
        attributes: offerB2W?.product?.attributes,
        description: offerB2W?.product?.description,
        id: offerB2W?.product?.id,
        images: offerB2W?.product?.images,
        name: offerB2W?.product?.name,
        price: offerB2W?.product?.price,
        rating: offerB2W?.product?.rating,
        isAvailable: false
      )

      //
    } else {
      offerLasa?.product?.attributes = product?.attributes
      offerLasa?.product?.id = product?.id
      offerLasa?.product?.images = product?.images
      offerLasa?.product?.isAvailable = product?.isAvailable ?? false
      offerLasa?.product?.name = product?.name ?? product?.description
      offerLasa?.product?.description = product?.description
      offerLasa?.product?.rating = product?.rating
      offerLasa?.product?.price = offerLasa?.product?.price ?? product?.price
    }
  }
}
