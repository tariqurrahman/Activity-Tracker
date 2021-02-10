//
//  Theme+CoreDataClass.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//
//

import Foundation
import CoreData
import UIKit

@objc(Theme)
public class Theme: NSManagedObject {
    
    class func create(mainScreenBGColor : UIColor? = nil , activityScreenBGColor : UIColor? = nil, buttonsColor : UIColor? = nil) -> Theme {
        let theme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: CoreDataHelper.context) as! Theme
        theme.mainScreenBackgroundColor = mainScreenBGColor?.toHex
        theme.activityScreenBackgroundColor = activityScreenBGColor?.toHex
        theme.mainScreenButtonsColor = buttonsColor?.toHex
        return theme
    }
    
    class func themeOfObjectID(objectID : NSManagedObjectID) -> Theme? {
        
        return try? CoreDataHelper.context.existingObject(with: objectID) as? Theme
        
    }
    
    class func fetchTheme() -> Theme? {
        
        do {
            let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
            let results = try CoreDataHelper.context.fetch(fetchRequest)
            return results.first
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return nil
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
    
    var mainScreenBGColor: UIColor? {
        get {
            guard let hex = mainScreenBackgroundColor else { return UIColor.white }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                mainScreenBackgroundColor = newColor.toHex
            }
        }
    }
    
    var activityScreenBGColor: UIColor?{
        get {
            guard let hex = activityScreenBackgroundColor else { return UIColor.white }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                activityScreenBackgroundColor = newColor.toHex
            }
        }
    }
    
    var buttonsColor: UIColor?{
        get {
            guard let hex = mainScreenButtonsColor else { return UIColor.white }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                mainScreenButtonsColor = newColor.toHex
            }
        }
    }

}

extension Theme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Theme> {
        return NSFetchRequest<Theme>(entityName: "Theme")
    }

    @NSManaged public var mainScreenBackgroundColor: String?
    @NSManaged public var activityScreenBackgroundColor: String?
    @NSManaged public var mainScreenButtonsColor: String?

}

extension Theme : Identifiable {

}
