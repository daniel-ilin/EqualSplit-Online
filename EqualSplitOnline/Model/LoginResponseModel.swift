//
//  LoginResponseModel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 10.01.2022.
//

import Foundation

// MARK: - ActiveUser
struct Token: Codable {
    var token: String?
    var error: String?
}
