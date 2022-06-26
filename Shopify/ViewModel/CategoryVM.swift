//
//  CategoryVM.swift
//  Shopify
//
//  Created by Moataz Hussein on 24/06/2022.
//

import Foundation

class CategoryViewModel {
    
    //MARK: - Initializer
    init(dataProvider: DataProviderProtocol) {
        
        self.dataProvider = dataProvider
        getSubCategories()
        getMainCategories()
        
    }

    //MARK: - Variable(s)
    var mainCategoriesList: Observable<CustomCollections> = Observable(nil)
    var subCategoriesList = [String]()
    var dataProvider: DataProviderProtocol
    let productsVM = ProductsViewModel(dataProvider: API())
    var filteredProducts = Observable<[Product]>([])
    
    //MARK: - Helper Funcs
    func getSubCategories() {
        
        productsVM.productsList.bind { [weak self] _ in
            guard let products = self?.productsVM.productsList.value?.products else { return }
            DispatchQueue.main.async {
                for product in products {
                    if !(self?.subCategoriesList.contains(product.product_type ?? "") ?? true) {
                        self?.subCategoriesList.append(product.product_type ?? "")
                    }
                }
                self?.filteredProducts.value = products
            }
        }
        
    }
    
    func getMainCategories() {
        
        dataProvider.get(urlStr: Constants.mainCategoryAPIUrl, type: CustomCollections.self) { result in
            DispatchQueue.main.async {
                self.mainCategoriesList.value = result
            }
        }

    }
    
    
    func searchProducts(searchStr:String)
    {
        filteredProducts.value = searchStr == "" ?
        productsVM.productsList.value?.products : productsVM.productsList.value?.products.filter{$0.title?.uppercased().contains(searchStr.uppercased()) ?? false}
    }
    
}