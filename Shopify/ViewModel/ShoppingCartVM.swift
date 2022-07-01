//
//  ShoppingCartVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 24/06/2022.
//

import UIKit
import CoreData

class ShoppingCartVM
{
    //MARK: - Init
    init(dataPersistant: DataPersistantProtocol)
    {
        self.dataPersistant = dataPersistant
        getData()
    }
    
    init(dataPersistant: DataPersistantProtocol,product:Product)
    {
        self.dataPersistant = dataPersistant
        getData()
        
        //if the product already exists
        if let productIndex = productList.value?.firstIndex(where:  { Int($0.id) == product.id})
        {
            let predicate = NSPredicate(format: "id == \(product.id ?? 0)")
            dataPersistant.editObject(type: CartProducts.self, predicate: predicate, valuesForKeys: ["qty" : productList.value?[productIndex].qty ?? 0 + 1])
        }
        else
        {
            addDataToCoreData(title: product.title ?? "", image: product.image?.src ?? "", price: product.variants?[0].price ?? "", id: product.id ?? 0, qty: 1, isCheckOut: false)
        }
        
        
    }
    
    //MARK: - Var(s)
    var dataPersistant: DataPersistantProtocol
    var productList = Observable<[CartProducts]>([])
    var priceSum = Observable<Float>(0)
    
    // MARK: - Add Data to Data-Base using CoreData
    func addDataToCoreData (title: String ,image: String ,price: String , id: Int , qty: Int , isCheckOut: Bool)
    {
        let dict = ["title": title, "image": image, "price": price, "id": id,"qty": qty,"isCheckedOut": isCheckOut] as [String : Any]
        dataPersistant.insertObject(entityName: "CartProducts", valuesForKeys: dict)
        getData()
    }
    
    
    // MARK: - Load Data form Data-Base ( CoreData )
    
    func getData ()
    {
        dataPersistant.get(type: CartProducts.self, predicate: nil)
        {
            [weak self] products in
            self?.productList.value = products
            calculateSum()
        }
    }
    
    
    
    // MARK: - updateData form Data-Base ( CoreData )
        
    func updateQty (isIncreasing : Bool , index : Int)
    {
        guard let product = productList.value?[index] else {return}
        
        var qty = Int(product.qty)
        if isIncreasing
        {
            qty += 1
        }
        else
        {
            if product.qty == 0{return}
            else {qty -= 1 }
        }
        
        let predicate = NSPredicate(format: "id == \(product.id)")
        dataPersistant.editObject(type: CartProducts.self, predicate: predicate, valuesForKeys: ["qty":qty])
        
        calculateSum()
    }
     
    
    // MARK: - Delete Data form Data-Base
        func deleteProduct (index : Int)
    {
        if let product = productList.value?[index]
        {
            dataPersistant.deleteObj(obj: product)
            productList.value?.remove(at: index)
            calculateSum()
        }

    }
    
    func calculateSum()
    {
        priceSum.value = productList.value?.map({Float($0.qty) * (Float($0.price ?? "") ?? 0)})
            .reduce(Float(0),+)
        
    }
}
