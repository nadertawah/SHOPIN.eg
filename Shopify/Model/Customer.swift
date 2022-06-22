//
//  Customer.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import Foundation

// MARK: - Welcome
struct CustomerModel: Codable
{
    var customers: [Customer]?
}

// MARK: - Customer
struct Customer: Codable
{
    var id: Int?
    var email: String?
    var accepts_marketing: Bool?
    var created_at, updated_at: String?
    var first_name, last_name: String?
    var orders_count: Int?
    var state: String?
    var total_spent: String?
    var last_order_id: Int?
    var note: String?
    var verified_email: Bool?
    var multipass_identifier: String?
    var tax_exempt: Bool?
    var phone: String?
    var tags: String?
    var last_order_name: String?
    var currency: String?
    var addresses: [Address]?
    var acceptsMarketingUpdatedAt: String?
    var marketingOptInLevel: String?
    var taxExemptions: [String]?
    var smsMarketingConsent: SMSMarketingConsent?
    var adminGraphqlAPIID: String?
    var defaultAddress: Address?
}

// MARK: - Address
struct Address: Codable
{
    var id, customer_id: Int?
    var first_name, last_name: String?
    var company: String?
    var address1: String?
    var address2: String?
    var city, province, country, zip: String?
    var phone, name: String?
    var province_code: String?
    var country_code, country_name: String?
    var addressDefault: Bool?
    
    enum CodingKeys: String, CodingKey
    {
            case id
            case customerID
            case firstName
            case lastName
            case company, address1, address2, city, province, country, zip, phone, name
            case provinceCode
            case countryCode
            case countryName
            case addressDefault
        }
}


// MARK: - SMSMarketingConsent
struct SMSMarketingConsent: Codable
{
    var state: String?
    var optInLevel: String?
    var consentUpdatedAt: String?
    var consentCollectedFrom: String?
}
