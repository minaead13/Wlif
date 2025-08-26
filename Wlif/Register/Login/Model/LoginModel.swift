//
//  LoginModel.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

struct UserModel: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let id: Int
    let name, email, image: String
    let code: Int?
}
