//
//  ULUrlManager.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//


import Foundation
class ULUrlManager {
    
    //let baseUrl = "https://j7iljhya5d.execute-api.us-east-1.amazonaws.com/staging/" //DummyAPI
    
    let baseUrl = "https://zge4dtfkq2.execute-api.us-east-1.amazonaws.com/dev/"
    
    
    class var sharedInstance: ULUrlManager {
        struct Singleton {
            static let instance = ULUrlManager()
        }
        return Singleton.instance
    }
    
    /*
     *method : usersLoginAPIUrl
     *param  : to login
     */
    func usersLoginAPIUrl() -> (String) {
        let userLoginAPI =  baseUrl+"api/v1/user"
        return userLoginAPI
    }
    
    /*
     *method : usersSignUpAPIUrl
     *param  : to signup
     */
    func usersSignUpAPIUrl() -> (String) {
        let userSignUpAPI =  baseUrl+"api/v1/user"
        return userSignUpAPI
    }
    
    /*
     *method : usersSignUpAPIUrl
     *param  : to confirm signup
     */
    func confirmRegistrationAPIUrl() -> (String) {
        let confirmRegistrationAPI =  baseUrl+"api/v1/user"
        return confirmRegistrationAPI
    }
    
    /*
     *method : resendOTPAPIUrl
     *param  : to resendOTP
     */
    func resendOTPAPIUrl() -> (String) {
        let resendOTPAPI =  baseUrl+"api/v1/user"
        return resendOTPAPI
    }

    
    /*
     *method : resetPasswordAPIUrl
     *param  : to resetpswd
     */
    func resetPasswordAPIUrl() -> (String) {
        let resetPasswordAPI =  baseUrl+"api/v1/user"
        return resetPasswordAPI
    }
    
    /*
     *method : getHubDetailsPerUserAPIUrl
     *param  : to get hub details per user
     */
    func getHubDetailsPerUserAPIUrl() -> (String) {
        let hubDetailsAPI =  baseUrl+"/api/v1/hub"
        return hubDetailsAPI
    }

    
    /*
     *method : getSensorDetailsByHubIdAPIUrl
     *param  : to get sensor details
     */
    func getSensorDetailsByHubIdAPIUrl() -> (String) {
        let sensorDetailsAPI =  baseUrl+"/api/v1/sensor"
        return sensorDetailsAPI
    }
    
    /*
     *method : updateSensorDetailsAPIUrl
     *param  : to update sensor details
     */
    func updateSensorDetailsAPIUrl() -> (String) {
        let sensorDetailsAPI =  baseUrl+"/api/v1/sensor"
        return sensorDetailsAPI
    }
}
    
