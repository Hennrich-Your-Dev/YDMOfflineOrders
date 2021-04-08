//
//  YDProduct.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import YDExtensions

public class YDProduct: Codable {
  // MARK: Properties
  public var attributes: [YDProductAttributesContainer]?
  public var description: String?
  public var id: String?
  public var ean: String?
  public var images: [YDProductImage]?
  public var name: String?
  public var price: Double?
  public var rating: YDProductRating?
  public var isAvailable: Bool = true

  // MARK: Computed variables
  public var image: String? {
    return images?.first?.medium ?? images?.first?.small ?? images?.first?.big
  }

  public var formatedPrice: String? {
    return price?.formatedPrice
  }

  // MARK: Init
  public init(
    attributes: [YDProductAttributesContainer]? = nil,
    description: String? = nil,
    id: String? = nil,
    ean: String? = nil,
    images: [YDProductImage]? = nil,
    name: String? = nil,
    price: Double? = nil,
    rating: YDProductRating? = nil,
    isAvailable: Bool = true
  ) {
    self.attributes = attributes
    self.description = description
    self.id = id
    self.ean = ean
    self.images = images
    self.name = name
    self.price = price
    self.rating = rating
    self.isAvailable = isAvailable
  }

  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    attributes = try? container.decode(
      [YDProductAttributesContainer].self,
      forKey: .attributes
    )

    description = try? container.decode(
      String.self,
      forKey: .description
    )

    id = try? container.decode(
      String.self,
      forKey: .id
    )

    images = try? container.decode(
      [YDProductImage].self,
      forKey: .images
    )

    name = try? container.decode(
      String.self,
      forKey: .name
    )

    price = try? container.decode(
      Double.self,
      forKey: .price
    )

    rating = try? container.decode(
      YDProductRating.self,
      forKey: .rating
    )

    isAvailable = true
  }
}

// MARK: Extensions
extension YDProduct {
  public func getHtmlDescription() -> NSMutableAttributedString? {
    guard let description = description?.data(using: .utf8) else { return nil }

    do {
      let attributedString = try NSMutableAttributedString(
        data: description,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
      )

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 3

      attributedString.addAttribute(
        NSAttributedString.Key.paragraphStyle,
        value: paragraphStyle,
        range: NSRange(location: 0, length: attributedString.length)
      )

      return attributedString
    } catch {
      return NSMutableAttributedString()
    }
  }

  public func getTechnicalInformation() -> [YDProductAttributes] {
    return attributes?.first?.properties ?? []
  }
}
