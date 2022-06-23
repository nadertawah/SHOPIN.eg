//
//  ProductsVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 23/06/2022.
//

import Foundation

class ProductsViewModel
{
    
    init(brand: String) {
        getProducts(from: brand)
    }

    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(nil)
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        API().get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [])
            }
        }
        
    }
    
}
