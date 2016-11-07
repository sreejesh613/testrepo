//
//  ULCommon.swift
//  ULCH
//
//  Created by Smitha on 07/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULCommon: NSObject {
    
    static let identifier = "Common"
    static let statusKey = "status"
    static let errorMessageKey = "errorMessage"
    
    //ULLoginViewController
    static let tokenKey = "token"
    
    //ULDashBoardViewController
    static let hubDetailsKey = "hubDetails"
    static let adminIndicatorKey = "adminIndicator"
    static let firmwareKey = "firmware"
    static let hubIdKey = "hubId"
    static let hubLocKey = "hubLoc"
    static let hubRegStatusKey = "hubRegStatus"
    static let hubStatusKey = "hubStatus"
    static let zWaveIndKey = "zWaveInd"
    
    //ULHubListViewController
    static let sensorDetailsKey = "sensorDetails"
    static let batteryStatusKey = "batteryStatus"
    static let sensorIdKey = "sensorId"
    static let sensorLocationKey = "sensorLocation"
    static let sensorNameKey = "sensorName"
    static let sensorStateKey = "sensorState"
    static let sensorStatusKey = "sensorStatus"
    static let sensorTypeKey = "sensorType"
    static let locImgKey = "locImage"

    
    static func getFCMToken() -> String
    {
        let FCMToken = UserDefaults.standard.object(forKey: FCMTokenKey) as! String
        return FCMToken
        
    }
    static func getEmail() -> String
    {
        let email = UserDefaults.standard.object(forKey: userEmailKey) as! String
        return email
        
    }
    
    
    static func getUserToken() -> String
    {
        var userToken = ""
        if (UserDefaults.standard.object(forKey: userTokenKey) != nil)
        {
            userToken = UserDefaults.standard.object(forKey: userTokenKey) as! String
        }
        return userToken
    }
}
