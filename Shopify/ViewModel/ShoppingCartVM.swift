//
//  ShoppingCartVM.swift
//  Shopify
//
//  Created by Mohamed Azooz on 24/06/2022.
//

import UIKit
import CoreData

class ShoppingCartVM {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var product: NSManagedObject?
    var productList = [CoreDataProdutc]()
    var productQty = 0
    
    static let instance = ShoppingCartVM()
    
    // MARK: - Add Data to Data-Base using CoreData
    
    func addDataToCoreData (title: String ,image: String ,price: String) {
        let viewContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName:"CartProducts",in: viewContext) else { return }
        
        let product = NSManagedObject(entity: entity,insertInto: viewContext)
        
        product.setValue(title, forKey: "title")
        product.setValue(image, forKey: "image")
        product.setValue(price, forKey: "price")
       
        appDelegate.saveContext()
        
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        //       print("Done")
    }
    
    
   // MARK: - Load Data form Data-Base ( CoreData )
       
       func getData () -> [CoreDataProdutc] {
           productList.removeAll()
           let viewContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartProducts")
           
           do {
               let products = try viewContext.fetch(fetchRequest)
             
               for product in products {
      
                   let cartProductModel = CoreDataProdutc.init(product: product)
                   productList.append(cartProductModel)
               }
               
               return productList
               
           } catch let error {
               print(error.localizedDescription)
               return []
           }
       }
    
    
    // MARK: - Delete Data form Data-Base
        func deletLeague (index : Int) {
            let viewContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartProducts")
            do {
                let products = try viewContext.fetch(fetchRequest)
          
                product = products[index]
            }
            catch let error {
                print(error.localizedDescription)
            }
            viewContext.delete(product!)
            appDelegate.saveContext()
            //        print("Delete")
        }
    
//    func calculateQty () -> Int{
//
//        return productQty += 1
//    }
    
    
    
    
    //    var products = [Product]()
    
    //    init ( product : Product) {
    //        products.append(product)
    //    }
}
