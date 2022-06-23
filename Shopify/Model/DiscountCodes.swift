//
//  DiscountCodes.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation

struct PriceRules: Codable {

    let price_rules: [PriceRule]
    
}

struct PriceRule: Codable {
    let value: String?
    let title: String?
}
