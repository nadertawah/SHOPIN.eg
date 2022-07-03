//
//  ProductCoreData+CoreDataProperties.swift
//  
//
//  Created by Nader Said on 27/06/2022.
//
//

import Foundation
import CoreData


extension ProductCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCoreData> {
        return NSFetchRequest<ProductCoreData>(entityName: "ProductCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var customerID: Int64
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var size: String?
}
