//
//  ProductsVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 23/06/2022.
//

import Foundation

class ProductsViewModel
{
    
    init(brand: String)
    {
        getProducts(from: brand)
        
        productsList.bind {[weak self] in self?.filteredProductList.value = $0?.products}
    }

    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(Products(products: []))
    var filteredProductList : Observable<[Product]> = Observable([])
    
    //MARK: - intent(s)
    func searchProducts(searchStr:String)
    {
        filteredProductList.value = searchStr == "" ?
        productsList.value?.products : productsList.value?.products.filter{$0.title?.uppercased().contains(searchStr.uppercased()) ?? false}
    }
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        API().get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [] )
            }
        }
        
    }
    
}
