//
//  CartProducts+CoreDataProperties.swift
//  
//
//  Created by Nader Said on 01/07/2022.
//
//

import Foundation
import CoreData


extension CartProducts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProducts> {
        return NSFetchRequest<CartProducts>(entityName: "CartProducts")
    }

    @NSManaged public var isCheckedOut: Bool
    @NSManaged public var qty: Int64
    @NSManaged public var variantID: Int64


}
