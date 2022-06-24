//
//  CategoryVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 24/06/2022.
//

import Foundation

class CategoryViewModel
{
    
    init(dataProvider: DataProviderProtocol, brand: String) {
        self.dataProvider = dataProvider
        getProducts(from: brand)
    }

    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(nil)
    var dataProvider: DataProviderProtocol
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        API().get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [])
            }
        }
        
    }
    
}
