//
//  Activity+CoreDataClass.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
    
    class func create(discription : String? = nil, date : Date? = nil, startTime : Date? = nil, endTime : Date? = nil) -> Activity {
        let activity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: CoreDataHelper.context) as! Activity
        activity.activityDiscription = discription
        activity.date = date
        activity.starttime = startTime
        activity.endtime = endTime
        activity.timestamp = Date()
        return activity
    }
    
    class func activityOfObjectID(objectID : NSManagedObjectID) -> Activity? {
        
        return try? CoreDataHelper.context.existingObject(with: objectID) as? Activity
        
    }
    
    class func fetchActivities(complition : (_ activities : [Activity]) -> Void) {
        
        do {
            let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let results = try CoreDataHelper.context.fetch(fetchRequest)
            complition(results)
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            complition([])
        }
    }
    
    class func deleteAllActivities(complition : (_ status : Bool) -> Void) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Activity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataHelper.container().persistentStoreCoordinator.execute(deleteRequest, with: CoreDataHelper.context)
            complition(true)
        } catch {
            complition(false)
        }
    }
    
    func save(complition : (_ status : Bool) -> Void){
        do {
            try CoreDataHelper.save()
            complition(true)
        }
        catch {
            complition(false)
        }
        
    }
    
    func delete(complition : (_ status : Bool) -> Void){
        CoreDataHelper.context.delete(self)
        do {
            try CoreDataHelper.save()
            complition(true)
        }
        catch {
            complition(false)
        }
    }

}


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var activityDiscription: String?
    @NSManaged public var starttime: Date?
    @NSManaged public var endtime: Date?
    @NSManaged public var timestamp: Date?

}

extension Activity : Identifiable {

}
