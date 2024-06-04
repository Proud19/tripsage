//
//  KeyChainUtility.swift
//  tripsage
//
//  Created by Proud Mpala on 5/29/24.
//

import Foundation

class KeyChainUtility {
    static func saveTokenToKeychain(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "tripsageService",
            kSecAttrAccount as String: "accessToken",
            kSecValueData as String: tokenData
        ]
        
        // Delete any existing items
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token successfully saved to Keychain")
        } else {
            print("Error saving token to Keychain: \(status)")
        }
    }
    
    static func retrieveTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "tripsageService",
            kSecAttrAccount as String: "accessToken",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr, let tokenData = dataTypeRef as? Data {
            return String(data: tokenData, encoding: .utf8)
        } else {
            print("Error retrieving token from Keychain: \(status)")
            return nil
        }
    }
    
    
    static func saveUserToKeychain(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "tripsageService",
            kSecAttrAccount as String: "userId",
            kSecValueData as String: tokenData
        ]
        
        // Delete any existing items
        SecItemDelete(query as CFDictionary)
        
        // Add the new item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("UserId successfully saved to Keychain")
        } else {
            print("Error saving token to Keychain: \(status)")
        }
    }
    
    static func retrieveUserIdFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "tripsageService",
            kSecAttrAccount as String: "userId",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr, let tokenData = dataTypeRef as? Data {
            return String(data: tokenData, encoding: .utf8)
        } else {
            print("Error retrieving token from Keychain: \(status)")
            return nil
        }
    }
    
    static func removeTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "tripsageService",
            kSecAttrAccount as String: "accessToken"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Token successfully removed from Keychain")
        } else {
            print("Error removing token from Keychain: \(status)")
        }
    }
}
