//
//  DBHelper.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit
import CoreData

class DBHelper: NSObject {
    class func getContext() -> NSManagedObjectContext
    {
        //sharedAppDelegate.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return sharedAppDelegate.persistentContainer.viewContext
        //let cdm = CoreDataManager.sharedInstance
        //return cdm.mainContext
    }
    
    class func saveDatabase(){
        if self.getContext().hasChanges {
            try? self.getContext().save()
        }
    }
    
    class func storeHeight(height : String) {
        let context = getContext()
        
        let heightObj = Height(context: context)
        heightObj.height = height
        
        do{
            try context.save()
            print("Data Saved")
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    class func storeWeight(weight : Int) {
        let context = getContext()
        
        let weightObj = Weight(context: context)
        weightObj.weight = Int32(weight)
        
        do{
            try context.save()
            print("Data Saved")
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    class func storeLocations(lat : Double, long : Double, currentTime : String) {
        let context = getContext()
        
        let locationObj = Location(context: context)
        locationObj.latitude = lat
        locationObj.longitude = long
        locationObj.currentTime = currentTime
        
        do{
            try context.save()
            print("Data Saved")
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    //get all Cash Discounts
    class func getAllLoctaions() -> [Location]?
    {
        let context = getContext()
        
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let fetchedData = try context.fetch(fetchRequest)
            return fetchedData
        }
        catch
        {
            print(error.localizedDescription)
        }
        return []
    }
    
    class func deleteLocationData() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            _ = try getContext().execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
}
