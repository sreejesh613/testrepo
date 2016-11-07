//
//  LocImageDetails+CoreDataProperties.swift
//  
//
//  Created by Smitha on 17/10/16.
//
//

import Foundation
import CoreData


extension LocImageDetails {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<LocImageDetails>(entityName: "LocImageDetails") as! NSFetchRequest<NSFetchRequestResult>;
    }

    @NSManaged public var sensorLocation: String?
    @NSManaged public var locImage: String?

}
