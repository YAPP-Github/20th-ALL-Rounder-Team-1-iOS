// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
