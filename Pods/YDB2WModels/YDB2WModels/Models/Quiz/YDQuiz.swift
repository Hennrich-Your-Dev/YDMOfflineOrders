//
//  YDQuiz.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 28/06/21.
//

import Foundation

public enum YDQuizType {
  case options
  case unknow
}

public class YDQuiz: Codable {
  // MARK: Properties
  public var id: String?
  public var title: String?
  public var options: [YDQuizOptions]

  // MARK: Computed variables
  public var type: YDQuizType = .options
  public var storedValue: Any?

  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case title
    case options = "children"
  }

  // MARK: Init
  public init(
    id: String?,
    title: String?,
    options: [YDQuizOptions],
    type: YDQuizType = .options
  ) {
    self.id = id
    self.title = title
    self.options = options
    self.type = type
  }
}

public class YDQuizOptions: Codable {
  var id: String?
  var title: String?

  public init(id: String?, title: String?) {
    self.id = id
    self.title = title
  }
}
