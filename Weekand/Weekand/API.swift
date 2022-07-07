// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class WeekandQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query weekand {
      weekand(customField: "test") {
        __typename
        hello
      }
    }
    """

  public let operationName: String = "weekand"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("weekand", arguments: ["customField": "test"], type: .nonNull(.object(Weekand.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(weekand: Weekand) {
      self.init(unsafeResultMap: ["__typename": "Query", "weekand": weekand.resultMap])
    }

    /// weekand 테스트 query
    public var weekand: Weekand {
      get {
        return Weekand(unsafeResultMap: resultMap["weekand"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "weekand")
      }
    }

    public struct Weekand: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Weekand"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hello", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(hello: String) {
        self.init(unsafeResultMap: ["__typename": "Weekand", "hello": hello])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var hello: String {
        get {
          return resultMap["hello"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "hello")
        }
      }
    }
  }
}
