//
//  UserDefaultsService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 3/1/22.
//

import Foundation
import KeychainSwift

struct KeychainService {
    static private let keychain = KeychainSwift()
    
    static private let accessTokenKey = "access_token"
    static private let refreshTokenKey = "refresh_token"
    
    
    static func getAccessToken() -> String? {
        return keychain.get(accessTokenKey)
    }
    
    static func setAccessTokenTo(_ token: String) {
        keychain.set(token, forKey: accessTokenKey)
    }
    
    static func removeAccessToken() {
        keychain.delete(accessTokenKey)
    }
    
    static func getRefreshToken() -> String? {
        return keychain.get(refreshTokenKey)
    }
    
    static func setRefreshTokenTo(_ token: String) {
        keychain.set(token, forKey: refreshTokenKey)
    }
    
    static func removeRefreshToken() {
        keychain.delete(refreshTokenKey)
    }
}
