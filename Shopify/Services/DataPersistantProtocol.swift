//
//  DataPersistantProtocol.swift
//  Shopify
//
//  Created by Nader Said on 26/06/2022.
//

import Foundation
import CoreData

protocol DataPersistantProtocol
{
    func get<T:NSManagedObject>(type : T.Type,predicate : NSPredicate? ,completion : ([T]) -> ())
    func deleteObj<T:NSManagedObject>(type : T.Type,predicate:NSPredicate)
    func insertObject(entityName : String,valuesForKeys: [String:Any])
    func setCurrency(currency: String)
}
