//
//  User.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Foundation

// MARK: - Error

struct APIError: Codable {
    let error: String
}

// MARK: - Tokens
struct Tokens: Codable {
    var accessToken: String?
    var refreshToken: String?
}

// MARK: - UserData
struct UserData: Codable {
    let activeUser: ActiveUser
    let sessions: [Session]
}


// MARK: - ActiveUser
struct ActiveUser: Codable {
    let name, email, id: String
    var token: Token?
}

// MARK: - WelcomeElement
struct Session: Codable {
    let id, name, ownerid: String
    let users: [User]
    let sessioncode: String
}

// MARK: - User
struct User: Codable {
    let userid: String
    let username: String
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Codable {
    let ownerid, date, id, sessionid: String
    let description: String
    let amount: String

    enum CodingKeys: String, CodingKey {
        case ownerid, date, id, sessionid
        case description
        case amount
    }
}

typealias Sessions = [Session]

extension Session {
    func totalSpent() -> Int {
        var total = 0
        for user in self.users {
            for transaction in user.transactions {
                let addAmount = Int(transaction.amount) ?? 0
                total += addAmount
            }
        }
        return total
    }
}
