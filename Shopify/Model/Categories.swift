//
//  Categories.swift
//  Shopify
//
//  Created by Moataz Hussein on 24/06/2022.
//

import Foundation

struct CustomCollections: Codable {
    
    var custom_collections: [MainCategory]
    
}

struct MainCategory: Codable {
    
    var id: UInt64
    var title: String?
    var sort_order: String?
    
}


