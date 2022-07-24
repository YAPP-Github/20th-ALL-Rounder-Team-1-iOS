//
//  KeychainManager.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Foundation

class KeyChainManager {
    
    static let shared = KeyChainManager()
    private let service = Bundle.main.bundleIdentifier
    
    private init() { }
    
    func create(account: KeyChainAccount, data: String) throws {
        let query = [kSecAttrService: service,
                     kSecClass: account.keyChainClass,
                     kSecAttrAccount: account.description,
                     kSecValueData: data.data(using: .utf8, allowLossyConversion: false)!] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        guard status == noErr else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func read(account: KeyChainAccount) throws -> String {
        let query = [kSecAttrService: service,
                     kSecClass: account.keyChainClass,
                     kSecAttrAccount: account.description,
                     kSecReturnData: true] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.itemNotFound
        }
        
        if status == errSecSuccess,
           let item = dataTypeRef as? Data,
           let data = String(data: item, encoding: String.Encoding.utf8) {
            return data
        } else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func delete(account: KeyChainAccount) throws {
        let query = [kSecAttrService: service,
                     kSecClass: account.keyChainClass,
                     kSecAttrAccount: account.description] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
}
