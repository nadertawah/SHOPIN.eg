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
    }
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        getProducts()
    }
    
    //MARK: - Variable(s)
    var productsList: Observable<Products> = Observable(nil)
    var dataProvider: DataProviderProtocol
    var selectedSubCategory = 0
    var selectedMainCategory = 0
    
    //MARK: - Helper Funcs
    func getProducts(from brand: String) {
        
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                self.productsList.value = Products(products: result?.products.filter { $0.vendor == brand } ?? [])
            }
        }
        
    }
    
    func getProducts(with subCategory: String?, and mainCategoryID: UInt64?) {
        
        var filteredList = Products(products: [])
        dataProvider.get(urlStr: Constants.productsAPIUrl, type: Products.self) { result in
            DispatchQueue.main.async {
                let preFilteredList = Products(products: result?.products.filter { $0.product_type == subCategory } ?? [])
                self.dataProvider.get(urlStr: Constants.collectsAPIUrl, type: Collects.self) { result in
                    let collections = Collects(collects: result?.collects.filter { $0.collection_id == mainCategoryID } ?? [])
                    for collection in collections.collects {
                        for product in preFilteredList.products {
                            if product.id ?? 0 == collection.product_id ?? 0 {
                                filteredList.products.append(product)
                            }
                        }
                    }
                    self.productsList.value = filteredList
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
