//
//  CoreData.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import Foundation
import CoreData

class CoreData
{
    var context: NSManagedObjectContext =
    {
        let container = NSPersistentContainer(name: "Shopify")
        container.loadPersistentStores
        { (_ , error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.viewContext
    }()

    // MARK: - Core Data Saving support

    func get<T:NSManagedObject>(type : T.Type ,completion : ([T]) -> ())
    {
        var items = [T]()
        do
        {
            let fetchReq = T.fetchRequest() as! NSFetchRequest<T>
            items = try context.fetch(fetchReq)
            completion(items)
        }
        catch
        {
            completion(items)
            print("Error retrieving data\n")
        }
    }
//
//    func saveContext ()
//    {
//        if context.hasChanges
//        {
//            do
//            {
//                try context.save()
//            }
//            catch
//            {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    func deleteObj<T:NSManagedObject>(type : T.Type,predicate:NSPredicate)
    {
        let fetchRequest = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = predicate
        let objects = try? context.fetch(fetchRequest)


        if let objects = objects , !objects.isEmpty
        {
            context.delete(objects[0])
        }

//        saveContext()
    }
}

