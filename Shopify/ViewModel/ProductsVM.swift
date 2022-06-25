//
//  ProductsVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 23/06/2022.
//

import Foundation

class ProductsViewModel
{
    
    init(dataProvider: DataProviderProtocol, brand: String) {
        self.dataProvider = dataProvider
        getProducts(from: brand)
        
        productsList.bind {[weak self] in self?.filteredProductList.value = $0?.products}
    }
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        getProducts()
    }

    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(Products(products: []))
    var filteredProductList : Observable<[Product]> = Observable([])
    var dataProvider: DataProviderProtocol

    //MARK: - intent(s)
    func searchProducts(searchStr:String)
    {
        filteredProductList.value = searchStr == "" ?
        productsList.value?.products : productsList.value?.products.filter{$0.title?.uppercased().contains(searchStr.uppercased()) ?? false}
    }
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [] )
            }
        }
        
    }
    
    func getProducts(using subCategory: String?, for mainCategory: String?) {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            if mainCategory == nil {
                DispatchQueue.main.async {
                    self.productsList.value = Products(products: result?.products.filter { $0.product_type == subCategory } ?? [])
                }
            }
        }
    }
    
    func getProducts() {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = result
            }
        }
        
    }
    
}
