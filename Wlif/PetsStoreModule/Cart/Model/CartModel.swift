//
//  CartModel.swift
//  Wlif
//
//  Created by OSX on 10/07/2025.
//

import Foundation

struct CartModel: Codable {
    var items: [Item]?
    var subtotal, tax, total, deliveryValue: String?
    
    enum CodingKeys: String, CodingKey {
        case items, subtotal, tax, total
        case deliveryValue = "delivery_value"
    }
}

struct Item: Codable {
    let id, productID: Int
    let name, store: String
    let image: String
    let price, size: String
    let qty: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, store, image, price, size, qty
    }
}
