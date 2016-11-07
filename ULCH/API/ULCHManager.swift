//
//  ULCHManager.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import UIKit

class ULCHManager: NSObject {
    
    class var sharedInstance: ULCHManager {
        struct Singleton {
            static let instance = ULCHManager()
        }
        return Singleton.instance
    }
    
    //PRAGMA MARK :- Authenticate user
    //Method to authenticate a user with email and password, success and failure block
    
    func registerUser(
        _ emailID : String, password : String, mobile : String, success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().post(ULUrlManager.sharedInstance.usersSignUpAPIUrl(), parameters: [
            "operation" : "createUser",
            "email":emailID,
            "password"  : password,
            "mobile" : mobile,
            ] , success: { (operation, response) -> Void in
                
                print(response)
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                    
                    print(responseObject)
                    
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }
    
    func confirmUserRegistration(
        _ OTPCode : String, snsId : String, mobile : String, success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().post(ULUrlManager.sharedInstance.confirmRegistrationAPIUrl(), parameters: [
            "operation" : "confirmUserRegistration",
            "mobile": mobile,
            "SnsId"  : snsId,
            "otpCode" : OTPCode,
            ] , success: { (operation, response) -> Void in
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }

    func resendOTP(
        _ emailID : String, mobile : String, success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().put(ULUrlManager.sharedInstance.resendOTPAPIUrl(), parameters: [
            "operation" : "sendOTP",
            "email":emailID,
            "mobile" : mobile,
            ] , success: { (operation, response) -> Void in
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }
    
    func loginUser(
        _ emailId  : String, password: String, snsId : String, success: (( _ response: AnyObject?)->())?, failure: (( _ error: NSError?,  _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().post(ULUrlManager.sharedInstance.usersLoginAPIUrl(), parameters: [
            "operation": "login",
            "userId": emailId,
            "password": password,
            "SnsId": snsId,
            ],success: { (operation, response) -> Void in
                                            
                                            //Get and parse the response
                                            if let responseObject = response as? [String:AnyObject]
                                            {
                                                //call the success block that was passed with response data
                                                success?(responseObject as AnyObject?)
                                            }
                                            else
                                            {
                                                //The response did not match the form we expected, error/fail
                                                failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                                            }
                                            
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }
    
    
    
    func getHubPerUser(
        _ success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().get(ULUrlManager.sharedInstance.getHubDetailsPerUserAPIUrl(), parameters: [
            "operation" : "getHubDetailsByUserId",
            ] , success: { (operation, response) -> Void in
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }

    func getSensorDetailsByHubId(
        _ hubId : String, success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().get(ULUrlManager.sharedInstance.getSensorDetailsByHubIdAPIUrl(), parameters: [
            "operation" : "getSensorDetailsByHubId",
            "hubId":hubId,
            ] , success: { (operation, response) -> Void in
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }
    

    func updateSensorDetails(
        _ hubId : String, sensorId : String, sensorName : String, sensorLocation : String, success: ((_ response: AnyObject?)->())?, failure: ((_ error: NSError?, _ code: String)->())?)
    {
        let requestManager = ULRequestManager.sharedInstance
        requestManager.httpManager().put(ULUrlManager.sharedInstance.updateSensorDetailsAPIUrl(), parameters: [
            "operation" : "updateSensor",
            "hubId": hubId,
            "sensorId": sensorId,
            "sensorName": sensorName,
            "sensorLocation": sensorLocation,
            "confirmInd":"TRUE"
            ] , success: { (operation, response) -> Void in
                
                //Get and parse the response
                if let responseObject = response as? [String:AnyObject]
                {
                    //call the success block that was passed with response data
                    success?(responseObject as AnyObject?)
                }
                else
                {
                    //The response did not match the form we expected, error/fail
                    failure?(NSError(domain: "Response error", code: 1, userInfo: nil), "ResponseInvalid")
                }
                
            }, failure: { (operation, error) -> Void in
                
                var failureErrorCode:String = ""
                //get the error code from API if any
                if let errorCode = requestManager.getFailureErrorCodeFromResponse(error as NSError?)
                {
                    failureErrorCode = errorCode
                }
                //The credentials were wrong or the network call failed
                failure?(error as NSError?, failureErrorCode)
        })
    }
}
