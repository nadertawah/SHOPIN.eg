//
//  CoreData.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import Foundation
import CoreData

class CoreData : DataPersistantProtocol
{
    //Default init
    init()
    {
        context =
        {
            let container = NSPersistentContainer(name: "ShopifyCoreData")
            container.loadPersistentStores
            { (_ , error) in
                if let error = error as NSError?
                {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container.viewContext
        }()
    }
    
    //Injected context
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    
    var context: NSManagedObjectContext
    
    //Saving support
    func saveContext ()
    {
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func get<T:NSManagedObject>(type : T.Type,predicate : NSPredicate? ,completion : ([T]) -> ())
    {
        var items = [T]()
        do
        {
            let fetchReq = T.fetchRequest() as! NSFetchRequest<T>
            fetchReq.predicate = predicate
            items = try context.fetch(fetchReq)
            completion(items)
        }
        catch
        {
            completion(items)
            print("Error retrieving data\n")
        }
    }
    
   
    func deleteObj<T:NSManagedObject>(type : T.Type,predicate:NSPredicate)
    {
        do
        {
            let fetchReq = T.fetchRequest() as! NSFetchRequest<T>
            fetchReq.predicate = predicate
            let objects = try context.fetch(fetchReq)
            
            if !objects.isEmpty
            {
                context.delete(objects[0])
            }

            saveContext()
        }
        catch
        {
            print("Error Deleting data\n")
        }
       
    }
    
    func insertObject(entityName : String,valuesForKeys: [String:Any])
    {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else{return}
        
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValuesForKeys(valuesForKeys)
        
        saveContext()
    }

}

