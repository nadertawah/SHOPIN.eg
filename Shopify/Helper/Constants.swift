//
//  Constants.swift
//  Shopify
//
//  Created by Nader Said on 21/06/2022.
//

import Foundation

struct Constants
{
    private static let APICredintials = "https://fde429753a207f610321a557c2e0ceb0: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@"
    
    static let brandsAPIUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-01/smart_collections.json"
      
    static let productsAPIUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/products.json"
    static let customersAPIUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/customers.json"
    static let shopifyHeader = ["X-Shopify-Access-Token":"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","Content-Type": "application/json"]
    
    // Currency ExchangeRates
    static let rates: [String : Float] = ["EGP" : 18.8, "USD" : 1, "EUR" : 0.95]

    //MARK: - ProductsVC Constants
    static let productCellReuseIdentifier = "productCell"
    
    //MARK: - HomeVC Constants
    static let brandCellReuseIdentifier = "brandCell"
    static let adCellReuseIdentifier = "adCell"
    

    //MARK: - CategoryVC Constants
    static let mainCategoryAPIUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/custom_collections.json"
    static let collectsAPIUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-01/collects.json"
    static let mainCategoryCellReuseIdentifier = "mainCategoryCell"
    static let subCategoryCellReuseIdentifier = "subCategoryCell"
    //MARK: - CheckOutVC Constants
    static let discountCodesUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/price_rules.json"

    //MARK: - AddressVC Constants
    static let AddressUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/customers/customerID/addresses.json"
    //MARK: - AddAddressVC Constants
    static let countryUrl = "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/countries.json"
    static let addAddressUrl =
    "https://menofia-2022-q3.myshopify.com/admin/api/2022-04/customers/customerID/addresses.json"

    
    static let productCoreDataEntityName = "ProductCoreData"
}
