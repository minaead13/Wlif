//
//  PetsStoresModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

struct PetsStoresModel: Codable {
    let id: Int
    let image: String
    let name, shortDesc, delivery, distance: String
    let rate: Int
    let minuim, closesAt: String

    enum CodingKeys: String, CodingKey {
        case id, image, name
        case shortDesc = "short_desc"
        case delivery, distance, rate, minuim
        case closesAt = "closes_at"
    }
}
