//
//  KeyChainError.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Foundation

enum KeyChainError: Error {
    case unhandledError(status: OSStatus)
    case itemNotFound
}
