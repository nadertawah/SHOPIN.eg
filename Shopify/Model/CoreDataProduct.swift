//
//  CoreDataProduct.swift
//  Shopify
//
//  Created by Mohamed Azooz on 25/06/2022.
//

import Foundation
import CoreData

struct CoreDataProdutc {
    var title : String?
    var image : String?
    var price : String?
    
    init(title: String, image: String, price: String) {
        self.title = title
        self.image = image
        self.price = price
    }
    
    init(product: NSManagedObject) {
        self.title = product.value(forKey: "title") as? String ?? ""
        self.image = product.value(forKey: "image") as? String ?? ""
        self.price = product.value(forKey: "price") as? String ?? ""
    }
}
