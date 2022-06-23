//
//  ProductDetails.swift
//  Shopify
//
//  Created by Nader Said on 21/06/2022.
//

import Foundation

struct ProductModel : Codable
{
    var product : Product
}

struct Products: Codable {
    var products: [Product]
}

// MARK: - Product
struct Product: Codable
{
    var id: Int?
    var title, body_html, vendor, product_type: String?
    var created_at,updated_at, published_at: String?
    var handle: String?
    var status, published_scope, tags, admin_graphql_api_id: String?
    var variants: [Variant]?
    var options: [Option]?
    var images: [Image]?
    var image: Image?
}

// MARK: - Variant
struct Variant: Codable
{
    var id, product_id: Int?
    var title, price, sku: String?
    var position: Int?
    var inventory_policy: String?
    var fulfillment_service, inventory_management, option1, option2,option3: String?
    var created_at, updated_at: String?
    var taxable: Bool?
    var barcode: String?
    var grams: Int?
    var image_id: String?
    var weight: Int?
    var weight_unit: String?
    var inventory_item_id, inventory_quantity, old_inventory_quantity: Int?
    var requires_shipping: Bool?
    var admin_graphql_api_id: String?
}


// MARK: - Option
struct Option: Codable
{
    var id, product_id: Int?
    var name: String?
    var position: Int?
    var values: [String]?
}



// MARK: - Image
struct Image: Codable
{
    var id, product_id, position: Int?
    var created_at, updated_at: String?
    var alt: String?
    var width, height: Int?
    var src: String?
    var variant_ids: [String]?
    var admin_graphql_api_id: String?
}
