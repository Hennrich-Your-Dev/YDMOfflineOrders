//
//  YDDeepLinksParser.swift
//  YDB2WDeepLinks
//
//  Created by Douglas Hennrich on 21/05/21.
//

import Foundation

import YDExtensions

public enum YDDeepLinksParser {
  // MARK: Enum
  public enum Types: String {
    case nps
  }

  // MARK: Actions
  public static func parse(url: URL) -> (
    path: YDDeepLinksParserTypes?,
    parameters: [String: Any]?
  ) {
    let allComponents = url.host.map { [$0] + url.pathComponents } ?? url.pathComponents
    let components = allComponents
      .filter { $0 != "/" }
      .map { $0.removingPercentEncoding ?? "" }

    var params: [String: String] = [:]

    if let parameters = url.queryParameters {
      for (key, value) in parameters {
        params[key.lowercased()] = value
      }
    }

    return (
      path: YDDeepLinksParserTypes(rawValue: components.last ?? ""),
      parameters: params
    )
  }
}

public enum YDDeepLinksParserTypes: String {
  case nps
}

public enum YDDeepLinksParserParameters: String {
  case storeId = "storeid"
  case eTag = "etag"
}
