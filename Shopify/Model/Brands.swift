//
//  Brands.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import Foundation

struct SmartCollections: Codable {
    
    var smart_collections: [Brand]
    
}

struct Brand: Codable {
    
    var title: String?
    var image: BrandImage
    
}

struct BrandImage: Codable {
    
    var src: String?
    
}
