//
//  ProductDetailsVM.swift
//  Shopify
//
//  Created by Nader Said on 21/06/2022.
//

import Foundation

class ProductDetailsVM
{
    init(dataProvider : DataProviderProtocol, productID : String)
    {
        self.dataProvider = dataProvider
        getProductDetails(productID: productID)
    }
    
    //MARK: - Var(s)
    //data provider service
    var dataProvider : DataProviderProtocol
    
    //VC binding closure
    var bind : (() -> ())?

    //VM model
    private(set) var product = Product() { didSet{bind?()} }
    
    
    //MARK: - intent(s)
    
    //MARK: - Helper Funcs
    func getProductDetails(productID : String)
    {
        let productDetailsURL = Constants.productsAPIUrl.replacingOccurrences(of: ".json", with: "/\(productID).json")
        dataProvider.get(urlStr: productDetailsURL, type: ProductModel.self)
        {
            [weak self] in
            self?.product = $0?.product ?? Product()
        }
    }
    
}
