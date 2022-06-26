//
//  Collects.swift
//  Shopify
//
//  Created by Moataz Hussein on 25/06/2022.
//

import Foundation

struct Collects: Codable {
    
    var collects: [Collect]

}

struct Collect: Codable {

    var collection_id: UInt64?
    var product_id: UInt64?

}
