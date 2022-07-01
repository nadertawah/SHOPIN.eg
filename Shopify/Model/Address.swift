//
//  Address.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import Foundation

struct Countries: Codable {

    let countries: [Country]
    
}

struct Country: Codable {
    
    let id: Int?
    let name: String?
    let code: String?
    let taxName: String?
    let tax: Double?
    let provinces: [Provinces]?

}

struct Provinces: Codable {
    
    let id: Int?
    let countryId: Int?
    let name: String?
    let code: String?
    let taxName: String?
    let taxType: String?
    let shippingZoneId: String?
    let tax: Int?
    let taxPercentage: Int?

}

struct Addresses: Codable {

    let addresses: [Address]?
}

// MARK: - Error
struct AddressErrorModel: Codable
{
    var errors: AddressErrors?
}

// MARK: - Errors
struct AddressErrors: Codable
{
    var signature: [String]?
}

