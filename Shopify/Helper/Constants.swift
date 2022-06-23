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
    
    static let productsAPIUrl = "\(APICredintials)menofia-2022-q3.myshopify.com/admin/api/2022-01/products.json"
    
    static let brandsAPIUrl = "\(APICredintials)menofia-2022-q3.myshopify.com/admin/api/2022-01/smart_collections.json"
    
    //MARK: - ProductsVC Constants
    static let productCellReuseIdentifier = "productCell"
    
    //MARK: - HomeVC Constants
    static let brandCellReuseIdentifier = "brandCell"
    static let adCellReuseIdentifier = "adCell"
    
    //MARK: - CategoryVC Constants
    static let mainCategoryCellReuseIdentifier = "mainCategoryCell"
    static let subCategoryCellReuseIdentifier = "subCategoryCell"

    
}
