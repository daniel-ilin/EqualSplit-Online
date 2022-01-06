//
//  User.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Foundation

// MARK: - WelcomeElement
struct Session: Codable {
    let id, name, ownerid: String
    let users: [User]
}

// MARK: - User
struct User: Codable {
    let userid: String
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Codable {
    let ownerid, date, id, sessionid: String
    let transactionDescription, amount: String

    enum CodingKeys: String, CodingKey {
        case ownerid, date, id, sessionid
        case transactionDescription
        case amount
    }
}

typealias Sessions = [Session]

