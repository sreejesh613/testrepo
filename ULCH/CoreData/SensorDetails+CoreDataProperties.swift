//
//  SensorDetails+CoreDataProperties.swift
//  
//
//  Created by Smitha on 17/10/16.
//
//

import Foundation
import CoreData


extension SensorDetails {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<SensorDetails>(entityName: "SensorDetails") as! NSFetchRequest<NSFetchRequestResult>;
    }

    @NSManaged public var batteryStatus: String?
    @NSManaged public var hubId: String?
    @NSManaged public var sensorId: String?
    @NSManaged public var sensorLocation: String?
    @NSManaged public var sensorName: String?
    @NSManaged public var sensorState: String?
    @NSManaged public var sensorStatus: String?
    @NSManaged public var sensorType: String?
    @NSManaged public var zWaveInd: String?

}
