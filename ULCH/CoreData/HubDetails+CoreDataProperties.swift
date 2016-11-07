//
//  HubDetails+CoreDataProperties.swift
//  
//
//  Created by Smitha on 14/10/16.
//
//

import Foundation
import CoreData


extension HubDetails {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<HubDetails>(entityName: "HubDetails") as! NSFetchRequest<NSFetchRequestResult>;
    }

    @NSManaged public var adminIndicator: String?
    @NSManaged public var firmware: String?
    @NSManaged public var hubId: String?
    @NSManaged public var hubLoc: String?
    @NSManaged public var hubRegStatus: String?
    @NSManaged public var hubStatus: String?
    @NSManaged public var zWaveInd: String?

}
