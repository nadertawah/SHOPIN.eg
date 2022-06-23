//
//  DiscountCodes.swift
//  Shopify
//
//  Created by Mohamed Azooz on 23/06/2022.
//

import Foundation

struct RootClass: Codable {

    let priceRules: [PriceRules]
    
}

struct PriceRules: Codable {

    let id: Int?
    let valueType: String?
    let value: String?
    let customerSelection: String?
    let targetType: String?
    let targetSelection: String?
    let allocationMethod: String?
    let allocationLimit: String?
    let oncePerCustomer: Bool?
    let usageLimit: String?
    let startsAt: String?
    let endsAt: String?
    let createdAt: String?
    let updatedAt: String?
    let entitledProductIds: [String]?
    let entitledVariantIds: [String]?
    let entitledCollectionIds: [String]?
    let entitledCountryIds: [String]?
    let prerequisiteProductIds: [String]?
    let prerequisiteVariantIds: [String]?
    let prerequisiteCollectionIds: [String]?
    let customerSegmentPrerequisiteIds: [String]?
    let prerequisiteCustomerIds: [String]?
    let prerequisiteSubtotalRange: String?
    let prerequisiteQuantityRange: String?
    let prerequisiteShippingPriceRange: String?
    let prerequisiteToEntitlementQuantityRatio: [String]?
    let prerequisiteToEntitlementPurchase: [String]?
    let title: String?
    let adminGraphqlApiId: String?

}
