//
//  Customer.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import Foundation

// MARK: - Customers Model
struct CustomersModel: Codable
{
    var customers: [Customer]?
}

// MARK: - Customer Model
struct CustomerModel: Codable
{
    var customer: Customer?
}

// MARK: - Customer
struct Customer: Codable
{
    var id: Int64?
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
    var accepts_marketing_updated_at: String?
    var marketing_opt_in_level: String?
    var tax_exemptions: [String]?
    var sms_marketing_consent: SMSMarketingConsent?
    var admin_graphql_api_id: String?
    var default_address: Address?
}

// MARK: - Address
struct Address: Codable
{
    var id, customer_id: Int64?
    var first_name, last_name: String?
    var company: String?
    var address1: String?
    var address2: String?
    var city, province, country, zip: String?
    var phone, name: String?
    var province_code: String?
    var country_code, country_name: String?
    var `default`: Bool?
}


// MARK: - SMSMarketingConsent
struct SMSMarketingConsent: Codable
{
    var state: String?
    var opt_in_level: String?
    var consent_updated_at: String?
    var consent_collected_from: String?
}


// MARK: - Error
struct CustomerErrorModel: Codable
{
    var errors: Errors?
}

// MARK: - Errors
struct Errors: Codable
{
    var email, phone: [String]?
}
