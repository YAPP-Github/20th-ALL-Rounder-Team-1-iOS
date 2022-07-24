//
//  KeychainManager.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/24.
//

import Foundation

class KeyChainManager {
    
    let shared = KeyChainManager()
    private let service = Bundle.main.bundleIdentifier
    
    private init() { }
    
    func create(account: String, data: String, KSecClass: CFString) throws {
        let query = [kSecAttrService: service,
                     kSecClass: KSecClass,
                     kSecAttrAccount: account,
                     kSecValueData: data] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func read(account: String, KSecClass: CFString) throws -> String {
        let query = [kSecAttrService: service,
                     kSecClass: KSecClass,
                     kSecAttrAccount: account,
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
    
    func delete(account: String, KSecClass: CFString) throws {
        let query = [kSecAttrService: service,
                     kSecClass: KSecClass,
                     kSecAttrAccount: account] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
}
