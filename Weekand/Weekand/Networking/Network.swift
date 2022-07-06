//
//  Network.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/02.
//

import Foundation
import Apollo

enum ListSection: Int, CaseIterable {
  case launches
}

class Network {
  static let shared = Network()

    private(set) lazy var apollo = ApolloClient(url: URL(string: Key.graphqlUrl)!)
}
