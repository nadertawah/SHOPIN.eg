//
//  Orders.swift
//  Shopify
//
//  Created by Moataz Hussein on 03/07/2022.
//

import Foundation

// MARK: - Order Model
struct Orders: Codable
{
    var orders: [Order]?
}

// MARK: - Order
struct Order: Codable
{
    var id: Int64?
    var closed_at: String?
    var email: String?
    var current_total_price: String?
    var customer: Customer?
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
