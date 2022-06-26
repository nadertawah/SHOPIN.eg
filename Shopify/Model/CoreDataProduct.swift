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
    var id : Int?
    var isCheckedOut : Bool?
    var qty : Int?
    
    init(title: String, image: String, price: String , id: Int ,isCheckedOut : Bool , qty: Int ) {
        self.title = title
        self.image = image
        self.price = price
        self.id = id
        self.isCheckedOut = isCheckedOut
        self.qty = qty
    }
    
    init(product: NSManagedObject) {
        self.title = product.value(forKey: "title") as? String ?? ""
        self.image = product.value(forKey: "image") as? String ?? ""
        self.price = product.value(forKey: "price") as? String ?? ""
        self.id = product.value(forKey: "id") as? Int ?? 0
        self.qty = product.value(forKey: "qty") as? Int ?? 0
        self.isCheckedOut = product.value(forKey: "isCheckedOut") as? Bool ?? false
    }
}
