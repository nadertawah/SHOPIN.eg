//
//  Orders.swift
//  Shopify
//
//  Created by Moataz Hussein on 03/07/2022.
//

import Foundation

// MARK: - Order Model
struct OrderModel: Codable
{
    var order: Order?
}

// MARK: - Order
struct Order: Codable
{
    var email: String?
    var fulfillment_status: String?
    var line_items: [Item]?
}

struct Item: Codable
{
    var variant_id: Int64?
    var quantity: Int?
}

// MARK: - Error
struct OrderErrorModel: Codable
{
    var errors: OrderErrors?
}

struct OrderErrors: Codable
{
    var email: String?
}
