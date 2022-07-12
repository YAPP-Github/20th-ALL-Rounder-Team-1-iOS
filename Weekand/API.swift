// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum ScheduleCategorySort: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case dateCreatedAsc
  case dateCreatedDesc
  case nameAsc
  case nameDesc
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DATE_CREATED_ASC": self = .dateCreatedAsc
      case "DATE_CREATED_DESC": self = .dateCreatedDesc
      case "NAME_ASC": self = .nameAsc
      case "NAME_DESC": self = .nameDesc
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .dateCreatedAsc: return "DATE_CREATED_ASC"
      case .dateCreatedDesc: return "DATE_CREATED_DESC"
      case .nameAsc: return "NAME_ASC"
      case .nameDesc: return "NAME_DESC"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ScheduleCategorySort, rhs: ScheduleCategorySort) -> Bool {
    switch (lhs, rhs) {
      case (.dateCreatedAsc, .dateCreatedAsc): return true
      case (.dateCreatedDesc, .dateCreatedDesc): return true
      case (.nameAsc, .nameAsc): return true
      case (.nameDesc, .nameDesc): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ScheduleCategorySort] {
    return [
      .dateCreatedAsc,
      .dateCreatedDesc,
      .nameAsc,
      .nameDesc,
    ]
  }
}

public enum ScheduleCategoryOpenType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case allOpen
  case followerOpen
  case closed
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ALL_OPEN": self = .allOpen
      case "FOLLOWER_OPEN": self = .followerOpen
      case "CLOSED": self = .closed
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .allOpen: return "ALL_OPEN"
      case .followerOpen: return "FOLLOWER_OPEN"
      case .closed: return "CLOSED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ScheduleCategoryOpenType, rhs: ScheduleCategoryOpenType) -> Bool {
    switch (lhs, rhs) {
      case (.allOpen, .allOpen): return true
      case (.followerOpen, .followerOpen): return true
      case (.closed, .closed): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ScheduleCategoryOpenType] {
    return [
      .allOpen,
      .followerOpen,
      .closed,
    ]
  }
}

public struct SignUpInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - email
  ///   - password
  ///   - nickname
  ///   - jobs
  ///   - interests
  ///   - signUpAgreed
  public init(email: String, password: String, nickname: String, jobs: Swift.Optional<[String]?> = nil, interests: Swift.Optional<[String]?> = nil, signUpAgreed: Bool) {
    graphQLMap = ["email": email, "password": password, "nickname": nickname, "jobs": jobs, "interests": interests, "signUpAgreed": signUpAgreed]
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var nickname: String {
    get {
      return graphQLMap["nickname"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nickname")
    }
  }

  public var jobs: Swift.Optional<[String]?> {
    get {
      return graphQLMap["jobs"] as? Swift.Optional<[String]?> ?? Swift.Optional<[String]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "jobs")
    }
  }

  public var interests: Swift.Optional<[String]?> {
    get {
      return graphQLMap["interests"] as? Swift.Optional<[String]?> ?? Swift.Optional<[String]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "interests")
    }
  }

  public var signUpAgreed: Bool {
    get {
      return graphQLMap["signUpAgreed"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "signUpAgreed")
    }
  }
}

public final class CheckDuplicateNicknameQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query checkDuplicateNickname($nickname: String!) {
      checkDuplicateNickname(nickname: $nickname)
    }
    """

  public let operationName: String = "checkDuplicateNickname"

  public var nickname: String

  public init(nickname: String) {
    self.nickname = nickname
  }

  public var variables: GraphQLMap? {
    return ["nickname": nickname]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("checkDuplicateNickname", arguments: ["nickname": GraphQLVariable("nickname")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkDuplicateNickname: Bool) {
      self.init(unsafeResultMap: ["__typename": "Query", "checkDuplicateNickname": checkDuplicateNickname])
    }

    /// 닉네임의 중복 여부를 체크한다
    public var checkDuplicateNickname: Bool {
      get {
        return resultMap["checkDuplicateNickname"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "checkDuplicateNickname")
      }
    }
  }
}

public final class IssueTempPasswordMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation issueTempPassword($email: String!) {
      issueTempPassword(input: {email: $email})
    }
    """

  public let operationName: String = "issueTempPassword"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("issueTempPassword", arguments: ["input": ["email": GraphQLVariable("email")]], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(issueTempPassword: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "issueTempPassword": issueTempPassword])
    }

    /// 임시 비밀번호를 발급한다
    public var issueTempPassword: Bool {
      get {
        return resultMap["issueTempPassword"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "issueTempPassword")
      }
    }
  }
}

public final class LoginQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Login($email: String!, $password: String!) {
      login(loginInput: {email: $email, password: $password}) {
        __typename
        refreshToken
        accessToken
      }
    }
    """

  public let operationName: String = "Login"

  public var email: String
  public var password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["loginInput": ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")]], type: .nonNull(.object(Login.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Query", "login": login.resultMap])
    }

    /// 로그인 한다
    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("refreshToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("accessToken", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(refreshToken: String, accessToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginResponse", "refreshToken": refreshToken, "accessToken": accessToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var refreshToken: String {
        get {
          return resultMap["refreshToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "refreshToken")
        }
      }

      public var accessToken: String {
        get {
          return resultMap["accessToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "accessToken")
        }
      }
    }
  }
}

public final class ScheduleCategoriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ScheduleCategories($sort: ScheduleCategorySort!, $page: Int!, $size: Int!) {
      scheduleCategories(sort: $sort, page: $page, size: $size) {
        __typename
        paginationInfo {
          __typename
          hasNext
        }
        scheduleCategories {
          __typename
          id
          name
          color
          openType
        }
      }
    }
    """

  public let operationName: String = "ScheduleCategories"

  public var sort: ScheduleCategorySort
  public var page: Int
  public var size: Int

  public init(sort: ScheduleCategorySort, page: Int, size: Int) {
    self.sort = sort
    self.page = page
    self.size = size
  }

  public var variables: GraphQLMap? {
    return ["sort": sort, "page": page, "size": size]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("scheduleCategories", arguments: ["sort": GraphQLVariable("sort"), "page": GraphQLVariable("page"), "size": GraphQLVariable("size")], type: .nonNull(.object(ScheduleCategory.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(scheduleCategories: ScheduleCategory) {
      self.init(unsafeResultMap: ["__typename": "Query", "scheduleCategories": scheduleCategories.resultMap])
    }

    /// 일정 카테고리 목록을 가져온다
    public var scheduleCategories: ScheduleCategory {
      get {
        return ScheduleCategory(unsafeResultMap: resultMap["scheduleCategories"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "scheduleCategories")
      }
    }

    public struct ScheduleCategory: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ScheduleCategoryList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginationInfo", type: .nonNull(.object(PaginationInfo.selections))),
          GraphQLField("scheduleCategories", type: .nonNull(.list(.nonNull(.object(ScheduleCategory.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(paginationInfo: PaginationInfo, scheduleCategories: [ScheduleCategory]) {
        self.init(unsafeResultMap: ["__typename": "ScheduleCategoryList", "paginationInfo": paginationInfo.resultMap, "scheduleCategories": scheduleCategories.map { (value: ScheduleCategory) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var paginationInfo: PaginationInfo {
        get {
          return PaginationInfo(unsafeResultMap: resultMap["paginationInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "paginationInfo")
        }
      }

      public var scheduleCategories: [ScheduleCategory] {
        get {
          return (resultMap["scheduleCategories"] as! [ResultMap]).map { (value: ResultMap) -> ScheduleCategory in ScheduleCategory(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ScheduleCategory) -> ResultMap in value.resultMap }, forKey: "scheduleCategories")
        }
      }

      public struct PaginationInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PaginationInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hasNext", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hasNext: Bool) {
          self.init(unsafeResultMap: ["__typename": "PaginationInfo", "hasNext": hasNext])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var hasNext: Bool {
          get {
            return resultMap["hasNext"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNext")
          }
        }
      }

      public struct ScheduleCategory: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ScheduleCategory"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("color", type: .nonNull(.scalar(String.self))),
            GraphQLField("openType", type: .nonNull(.scalar(ScheduleCategoryOpenType.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, color: String, openType: ScheduleCategoryOpenType) {
          self.init(unsafeResultMap: ["__typename": "ScheduleCategory", "id": id, "name": name, "color": color, "openType": openType])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var color: String {
          get {
            return resultMap["color"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "color")
          }
        }

        public var openType: ScheduleCategoryOpenType {
          get {
            return resultMap["openType"]! as! ScheduleCategoryOpenType
          }
          set {
            resultMap.updateValue(newValue, forKey: "openType")
          }
        }
      }
    }
  }
}

public final class SendAuthKeyQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query sendAuthKey($email: String!) {
      sendAuthKey(email: $email)
    }
    """

  public let operationName: String = "sendAuthKey"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendAuthKey", arguments: ["email": GraphQLVariable("email")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendAuthKey: Bool) {
      self.init(unsafeResultMap: ["__typename": "Query", "sendAuthKey": sendAuthKey])
    }

    /// 이메일 인증 키를 발급한다
    public var sendAuthKey: Bool {
      get {
        return resultMap["sendAuthKey"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendAuthKey")
      }
    }
  }
}

public final class SignUpMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SignUp($signUpInput: SignUpInput!) {
      signUp(signUpInput: $signUpInput)
    }
    """

  public let operationName: String = "SignUp"

  public var signUpInput: SignUpInput

  public init(signUpInput: SignUpInput) {
    self.signUpInput = signUpInput
  }

  public var variables: GraphQLMap? {
    return ["signUpInput": signUpInput]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signUp", arguments: ["signUpInput": GraphQLVariable("signUpInput")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signUp: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "signUp": signUp])
    }

    /// 회원가입을 한다
    public var signUp: Bool {
      get {
        return resultMap["signUp"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "signUp")
      }
    }
  }
}

public final class VaildAuthKeyQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query vaildAuthKey($authKey: String!, $email: String!) {
      validAuthKey(validAuthKeyInput: {authKey: $authKey, email: $email})
    }
    """

  public let operationName: String = "vaildAuthKey"

  public var authKey: String
  public var email: String

  public init(authKey: String, email: String) {
    self.authKey = authKey
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["authKey": authKey, "email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("validAuthKey", arguments: ["validAuthKeyInput": ["authKey": GraphQLVariable("authKey"), "email": GraphQLVariable("email")]], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(validAuthKey: Bool) {
      self.init(unsafeResultMap: ["__typename": "Query", "validAuthKey": validAuthKey])
    }

    /// 이메일 인증 키를 검증한다
    public var validAuthKey: Bool {
      get {
        return resultMap["validAuthKey"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "validAuthKey")
      }
    }
  }
}
