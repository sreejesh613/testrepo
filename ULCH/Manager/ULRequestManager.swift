//
//  ULRequestManager.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//

import Foundation

class ULRequestManager {
    
    var timeoutInterval: TimeInterval {
        return 15.0
    }
    
    class var sharedInstance: ULRequestManager {
        struct Singleton {
            static let instance = ULRequestManager()
        }
        return Singleton.instance
    }
    
    func httpManager() -> AFHTTPRequestOperationManager {
        let http = AFHTTPRequestOperationManager()
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.timeoutInterval = timeoutInterval
        
        if (UserDefaults.standard.object(forKey: userTokenKey) != nil)
        {
            requestSerializer.setValue(ULCommon.getUserToken(), forHTTPHeaderField: "Authorization")
        }
        http.requestSerializer = requestSerializer
        return http
    }
    
    func httpManagerWithApiKey(_ apiKey: String?) -> AFHTTPRequestOperationManager? {
        let http = AFHTTPRequestOperationManager()
        if (apiKey == nil) {
            return nil
        }
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue(apiKey, forHTTPHeaderField: "X-ATTENDWARE-KEY")
        requestSerializer.timeoutInterval = timeoutInterval
        http.requestSerializer = requestSerializer
        return http
    }
    
    func imageHttpManagerWithUrl(_ url: String) -> AFHTTPRequestOperation? {
        let nsUrl = URL(string: url)
        let imageRequest: URLRequest = URLRequest(url: nsUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        let request: AFHTTPRequestOperation = AFHTTPRequestOperation(request: imageRequest)
        request.responseSerializer = AFImageResponseSerializer() as AFHTTPResponseSerializer
        return request
    }
    
    func validConnection() -> Bool {
        return ULConnectivity.reachabilityForInternetConnection().currentReachabilityStatus().rawValue != 0
    }
    
    func getFailureErrorMessageFromResponse(_ error: NSError?) -> String?
    {
        var errorMessage:String?
        if let error = error
        {
            let responseErrorData:Data? = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            if let errorData = responseErrorData
            {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: errorData, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                    if let errorMsg = jsonData[apiErrorMessageKey]
                    {
                        errorMessage = errorMsg as? String
                    }
                } catch {
                    errorMessage = nil
                }
            }
        }
        return errorMessage
    }
    
    func getFailureErrorCodeFromResponse(_ error: NSError?) -> String?
    {
        var errorCode:String?
        if let error = error
        {
            let responseErrorData:Data? = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            if let errorData = responseErrorData
            {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: errorData, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                    if let errorC = jsonData[apiErrorCodeKey]
                    {
                        errorCode = errorC as? String
                    }
                } catch {
                    errorCode = nil
                }
            }
        }
        return errorCode
    }
    
    func getFailureDeveloperMessageFromResponse(_ error: NSError?) -> String?
    {
        var errorCode:String?
        if let error = error
        {
            let responseErrorData:Data? = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
            if let errorData = responseErrorData
            {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: errorData, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                    if let errorC = jsonData[apiDeveloperFailureMessage]
                    {
                        errorCode = errorC as? String
                    }
                } catch {
                    errorCode = nil
                }
            }
        }
        return errorCode
    }
}
